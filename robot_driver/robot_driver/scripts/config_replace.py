"""
This script is invoked by a Robot pipeline.
The purpose is intended to:
1. copy the master config.json file to the runtime directory, and
2. replace credential passwords with values from a key vault.

"""

import os
import json
import argparse
from argparse import RawTextHelpFormatter


class AcceptRejectTracker:
    """Simple container for tracking and reporting accept/reject activity"""

    def __init__(self, name):
        self.name = name
        self.accepted = []
        self.rejected = []

    def note_accepted(self, context):
        """Add an accepted item"""
        self.accepted.append(context)

    def note_reject(self, context):
        """Add a rejected item"""
        self.rejected.append(context)

    def get_total(self):
        """return the current totals"""
        return len(self.accepted) + len(self.rejected)

    def report(self):
        """print the current summary"""
        print(f"{self.name}: Accepted: {len(self.accepted)}, Rejected: {len(self.rejected)}")
        if len(self.accepted) > 0:
            print("Accepted:")
            for item in self.accepted:
                print(f"  {item}")
        if len(self.rejected) > 0:
            print("Rejected:")
            for item in self.rejected:
                print(f"  {item}")


tracker = AcceptRejectTracker("\nPassword replace operations")


def parse_arguments(descr):
    """
    Standard command-line arguments.
    """
    parser = argparse.ArgumentParser(
        fromfile_prefix_chars="@",
        formatter_class=RawTextHelpFormatter,
        description=descr,
    )

    parser.add_argument(
        "-i", "--input", default="C:\\agent\\config.json", type=str, help="\t\tThe input master config.json file.\n"
    )
    parser.add_argument(
        "-o", "--output", default=None, required=True, type=str, help="\t\tThe output config.json file.\n"
    )

    parser.add_argument(
        "-b", "--blob", default="unspecified", required=False, type=str, help="\t\tThe key vault value.\n"
    )

    parser.add_argument(
        "-s",
        "--searchfor",
        default="username",
        type=str,
        help="\t\tThe field name to use for matching in the config.json file.\n",
    )

    parser.add_argument(
        "-r", "--replace", default="password", type=str, help="\t\tThe field name whos value is replaced upon match.\n"
    )

    parser.add_argument(
        "-k",
        "--keyvalpair",
        # required=True,    # default behavior is a simple copy of in --> out
        default=[],
        type=str,
        action="append",
        help="\t\tKey-Value pairs in the form of 'key:value'.\n\n",
    )

    return parser.parse_args()


def load_json_file(filename):
    """
    Return the JSON from JSON a file.
    Params:
        filename: The JSON file to open and read.
    """

    def _loadit(fullfilename):
        with open(fullfilename, encoding="utf-8") as reader:
            return json.loads(reader.read())

    # Use abspath() so failures show the actual path used.
    fullfilename = os.path.abspath(filename)
    print(f"Loaded master config file: {fullfilename}")
    return _loadit(fullfilename)


def do_replacements(args, keyname: str, robot_config, new_kv_pairs):
    """
    Recursivly traverse the entire config JSON, searching and replacing all matches.
    """
    if not isinstance(robot_config, dict):
        return
    if args.searchfor in robot_config:
        if args.replace not in robot_config:
            # Track this reject?
            print(f"Found '{args.searchfor}' BUT NOT '{args.replace}' in '{keyname}'")
            return

        # print(f"FOUND both '{args.searchfor}' and '{args.replace}' in '{keyname}'")
        found_value = robot_config[args.searchfor].lower()

        # Check if any of the replacements match this entry:
        for key, value in new_kv_pairs.items():
            if key == found_value:
                # Do not log the old password value: value_dict[args.replace]
                # Do not log pieces[1] - the new password
                tracker.note_accepted(f"Matched - '{args.searchfor}': '{found_value}', '{args.replace}' replaced")
                robot_config[args.replace] = value
                return
        tracker.note_reject(
            f"Skipped - '{args.searchfor}': '{found_value}' does not match any of the {len(new_kv_pairs)} keys."
        )
    else:
        # Note 'else': Ignore nested password definitions - by design.
        for key, value in robot_config.items():
            do_replacements(args, key, value, new_kv_pairs)


def main():
    """Main loop for copying and edititing the master Robot config.json"""
    args = parse_arguments("Copy config.json with replacements.")

    # Do not print passwords:
    # print(f"The raw blob is: {args.blob}")
    # print(f"The raw kv list is: {args.keyvalpair}")

    # Blob expected format:
    # "{username: password, ...}"
    theblob = str(args.blob).strip("{}").replace('"', "")
    kvdict = {}

    def accumulate_entries(context, the_list: list, the_dict: dict):
        for entry in the_list:
            kv = entry.split(
                ":", 1
            )  # split into the key (username(email), displayname. etc.) and everything else (the password)

            # Sanity checks
            if len(kv) != 2:
                print(f"ERROR: kv entry {context} is short and IGNORED: {kv}")
                continue

            kv[0] = kv[0].strip()
            # email addresses are always case-insensitive:
            if args.searchfor == "username":
                kv[0] = kv[0].lower()

            if kv[0] in the_dict:
                # Already know this key!
                if the_dict[kv[0]] == kv[1].strip():
                    print(f"Warning: duplicate kv {context} supplied for '{kv[0]}'")
                else:
                    print(
                        f"ERROR: duplicate key {context} supplied for '{kv[0]}' but has different value - duplicate IGNORED"
                    )
                continue
            the_dict[kv[0]] = kv[1].strip()

    if theblob.lower() != "unspecified":
        accumulate_entries("from -b option", theblob.split(","), kvdict)
    accumulate_entries("from -k options", args.keyvalpair, kvdict)

    # Here, all '-b' or '-k' key-values have been added into kvdict.
    # WARN: do not print 'kvdict' - it will log passwords too!
    print(f"The resultant key-value keys: {kvdict.keys()}")

    with open(args.input, encoding="utf-8") as f:
        data = json.load(f)

    # If no kv args are specified, just copy input to output.
    if len(kvdict) > 0:
        do_replacements(args, "ROOT", data, kvdict)

    with open(args.output, "w", encoding="utf-8") as f:
        json.dump(data, f, indent="    ")

    tracker.report()

    if len(tracker.rejected) != 0:
        print(f"WARNING: {tracker.get_total()} attempted, but {len(tracker.rejected)} were rejected.")
    else:
        print(f"Done, {tracker.get_total()} replacements")


if __name__ == "__main__":
    main()
