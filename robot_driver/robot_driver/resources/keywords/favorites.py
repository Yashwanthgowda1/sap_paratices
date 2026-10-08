from enum import Enum
from selenium.webdriver.support import expected_conditions as EC
from Libraries import Selectors, shared_utils
from resources.keywords import common

favorites_selectors = Selectors.load_json_file("resources/Page_objects/favorites.json")
calls_dict = Selectors.load_json_file("resources/Page_objects/Calls.json")


class FavoritesGroup(Enum):
    SPEED_DIAL = "Speed dial"
    PEOPLE_YOU_SUPPORT = "People you support"
    YOUR_DELEGATES = "Your delegates"


def favorites_module_sanity(device_list):
    # Sanity check everything here
    for device in shared_utils.make_list(device_list):
        # sanity: Make sure we are on the Calls/Favorites page:
        if common.is_element_present(device, calls_dict, "favorites_without_contacts_grid"):
            print(f"{device}: Looks like this favorites page is empty.")
        elif common.is_element_present(device, favorites_selectors, "favorites_all_grid_elements"):
            print(f"{device}: Looks like the favorites page.")
        else:
            print(f"{device}: WARN: This does not looks like the favorites page!")

        for group in FavoritesGroup:
            print(f"{device}: Checking group: {group.value}")
            if not is_favorites_group_present(device, group):
                print(f"{device}: Favorites group '{group.value}' is not present.")
            else:
                print(f"{device}: Favorites group '{group.value}' is present.")

                # Ensure the group is expanded to see its users
                _was_expanded = is_favorites_group_expanded(device, group)
                if not _was_expanded:
                    favorites_expand_group(device, group)

                _names_in_group = get_names_in_group(device, group)
                print(f"{device}: Favorites group '{group.value}' contains: {_names_in_group}")

                # Be nice, put it back the way we found it:
                if not _was_expanded:
                    favorites_shrink_group(device, group)


def get_names_in_group(device, group_ename: FavoritesGroup):
    """
    Gather and return a list of user names within the specified favorites group.
    """
    if not isinstance(group_ename, FavoritesGroup):
        raise ValueError(f"{device}: Illegal group_name argument: '{group_ename}'")

    user_names = []

    group_index = _get_index_of_favorites_group(device, group_ename)
    print(f"{device}: Group_index is: {group_index}")
    if group_index == -1:
        raise AssertionError(f"{device}: Favorites group '{group_ename.value}' not found.")

    # Fetch all elements in the favorites grid
    all_elements = common.wait_for_element(
        device, favorites_selectors, "favorites_all_grid_elements", cond=EC.presence_of_all_elements_located
    )
    print(f"{device}: All elements length is: {len(all_elements)}")

    # There should have been at least 1!
    if group_index >= len(all_elements) - 1:
        raise AssertionError(f"{device}: No expanded group found after '{group_ename.value}'.")

    # The expanded group 'user-detail' elements begin after the group header
    while group_index < len(all_elements) - 1:
        group_index += 1
        _classname = all_elements[group_index].get_attribute("class")
        if _classname == "android.widget.Button":
            # Encountered the next group header, we are done.
            break
        elif _classname != "android.view.ViewGroup":
            raise AssertionError(f"{device}: Unexpected class in all_elements list:'{_classname}'")

        else:
            # Here, we know the index of a single user-detail (ViewGroup), we can construct a locator for the user-detail name element (a TextView.text)
            # Add the group name and user-detail index to the generic selector:
            user_detail_selector = common.get_dict_copy(
                favorites_selectors, "favorites_generic_user_detail", "replace_section", group_ename.value
            )
            user_detail_selector = common.get_dict_copy(
                user_detail_selector, "favorites_generic_user_detail", "replace_index", str(group_index)
            )
            user_names.append(
                common.wait_for_element(device, user_detail_selector, "favorites_generic_user_detail").get_attribute(
                    "text"
                )
            )
    return user_names


def is_favorites_group_present(device, group_ename: FavoritesGroup):
    if not isinstance(group_ename, FavoritesGroup):
        raise ValueError(f"{device}: Illegal group_name argument: '{group_ename}'")
    # Check if group is present:
    group_selector = common.get_dict_copy(
        favorites_selectors, "favorites_section_replace", "replace_this", group_ename.value
    )
    return common.is_element_present(device, group_selector, "favorites_section_replace")


def _get_index_of_favorites_group(device, group_ename: FavoritesGroup) -> int:
    #
    #   Favorites groups:
    #   if the group (a Button) is 'expanded' it is immediatly followed by a 'android.view.ViewGroup' having an 'index' of one more than
    #   that of the group_element index.
    #   However, there is no way to fetch the 'index' property - so we have to calculate it.
    #
    # Fetch everything shown (section Buttons, and detail ViewGroups):
    all_elements = common.wait_for_element(
        device, favorites_selectors, "favorites_all_grid_elements", cond=EC.presence_of_all_elements_located
    )
    element_count = len(all_elements)

    # print(f"{device}: favorites container, element_count={element_count}")

    for _the_index in range(len(all_elements)):
        _classname = all_elements[_the_index].get_attribute("class")
        # print(f"{device}: element[{_the_index}] is a '{_classname}'")
        if _classname == "android.widget.Button":
            _section_name = all_elements[_the_index].get_attribute("content-desc")
            # print(f"{device}: Index {_the_index}: section header for '{_section_name}'.")
            if _section_name == group_ename.value:
                return _the_index
        elif _classname != "android.view.ViewGroup":
            raise AssertionError(f"{device}: Unexpected class in favorites list:'{_classname}'")
    return -1  # Not found!


def is_favorites_group_expanded(device, group_ename: FavoritesGroup) -> bool:
    # Determine if the next element in the favorites list after the group_name is another
    #   group_name ('shrunk'), or a user-detail (expanded)
    #
    group_name_index = _get_index_of_favorites_group(device, group_ename)
    if group_name_index == -1:
        print(f"{device}: Favorites group '{group_ename.value}', not found.")
        return False

    # print(f"{device}: Favorites group '{group_ename.value}', index is '{group_name_index}'")
    try:
        expanded_index_expected = str(int(group_name_index) + 1)
    except ValueError:
        raise AssertionError(
            f"{device}: Favorites group '{group_ename.value}' - cannot convert index '{group_name_index}'"
        )

    expanded_group_selector = common.get_dict_copy(
        favorites_selectors, "favorites_section_expanded_replace", "replace_index", str(expanded_index_expected)
    )

    if not common.is_element_present(device, expanded_group_selector, "favorites_section_expanded_replace"):
        print(f"{device}: Favorites group '{group_ename.value}' is not expanded")
        return False
    print(f"{device}: Favorites group '{group_ename.value}' is expanded")
    return True


def favorites_shrink_group(device, group_ename: FavoritesGroup):
    group_element = is_favorites_group_present(device, group_ename)
    if not group_element:
        print(f"{device}: Cannot shrink '{group_ename.value}': group not present")
        return
    if is_favorites_group_expanded(device, group_ename):
        group_element.click()
        print(f"{device}: Shrank Favorites group '{group_ename.value}'")
        return
    print(f"{device}: Favorites group '{group_ename.value}' was already shrunk")


def favorites_expand_group(device, group_ename: FavoritesGroup):
    group_element = is_favorites_group_present(device, group_ename)
    if not group_element:
        print(f"{device}: Cannot expand '{group_ename.value}': group not present")
        return
    if not is_favorites_group_expanded(device, group_ename):
        group_element.click()
        print(f"{device}: Expanded Favorites group '{group_ename.value}'")
        return
    print(f"{device}: Favorites group '{group_ename.value}' was already expanded")


def click_on_user_more_options(device, group_ename: FavoritesGroup, user_name):
    # Click on the 'More Options' assiciated with user 'user_name' in section 'group_name'
    print(f"{device}: click_on_more_options: group_ename={group_ename.value} user_name={user_name}")

    # Add the group name and user to the generic selector:
    more_options_selector = common.get_dict_copy(
        favorites_selectors, "favorites_generic_more_options_for_user", "replace_section", group_ename.value
    )
    more_options_selector = common.get_dict_copy(
        more_options_selector, "favorites_generic_more_options_for_user", "replace_username", user_name
    )

    common.wait_for_and_click(device, more_options_selector, "favorites_generic_more_options_for_user")
