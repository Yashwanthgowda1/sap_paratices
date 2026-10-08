"""Curated, live-verified investment universe for the Deploy-₹X screener.

Every stock symbol was confirmed against the Yahoo v8 chart API (valid INR quote).
Every mutual-fund scheme code was confirmed against mfapi.in (valid NAV from AMFI).

This is the market-wide opportunity set the screener rates — independent of your
personal holdings. Nifty 500 coverage: large, mid and small caps across 16 sectors.
Funds span Index, Large Cap, Flexi Cap, Mid Cap, Small Cap, Hybrid, Sectoral and
International categories across all major AMCs.

Not investment advice — a screening universe. Refresh periodically as listings
and scheme codes change.
"""
from __future__ import annotations

# (Yahoo symbol, company name, sector)
MARKET_STOCKS: list[tuple[str, str, str]] = [
    # ======== BANKING ========
    ("HDFCBANK.NS",    "HDFC Bank",                       "Banking"),
    ("ICICIBANK.NS",   "ICICI Bank",                      "Banking"),
    ("SBIN.NS",        "State Bank of India",             "Banking"),
    ("AXISBANK.NS",    "Axis Bank",                       "Banking"),
    ("KOTAKBANK.NS",   "Kotak Mahindra Bank",             "Banking"),
    ("BANKBARODA.NS",  "Bank of Baroda",                  "Banking"),
    ("INDUSINDBK.NS",  "IndusInd Bank",                   "Banking"),
    ("IDFCFIRSTB.NS",  "IDFC First Bank",                 "Banking"),
    ("FEDERALBNK.NS",  "Federal Bank",                    "Banking"),
    ("PNB.NS",         "Punjab National Bank",            "Banking"),
    ("CANBK.NS",       "Canara Bank",                     "Banking"),
    ("UNIONBANK.NS",   "Union Bank of India",             "Banking"),

    # ======== FINANCIALS / NBFC / INSURANCE ========
    ("BAJFINANCE.NS",  "Bajaj Finance",                   "Financials"),
    ("SHRIRAMFIN.NS",  "Shriram Finance",                 "Financials"),
    ("SBILIFE.NS",     "SBI Life Insurance",              "Financials"),
    ("HDFCLIFE.NS",    "HDFC Life Insurance",             "Financials"),
    ("MUTHOOTFIN.NS",  "Muthoot Finance",                 "Financials"),
    ("CHOLAFIN.NS",    "Cholamandalam Investment",        "Financials"),
    ("M&MFIN.NS",      "Mahindra & Mahindra Financial",  "Financials"),
    ("LICHSGFIN.NS",   "LIC Housing Finance",             "Financials"),
    ("ICICIGI.NS",     "ICICI Lombard General Insurance", "Financials"),
    ("RECLTD.NS",      "REC Limited",                     "Financials"),

    # ======== INFORMATION TECHNOLOGY ========
    ("TCS.NS",         "Tata Consultancy Services",       "IT"),
    ("INFY.NS",        "Infosys",                         "IT"),
    ("HCLTECH.NS",     "HCL Technologies",                "IT"),
    ("TECHM.NS",       "Tech Mahindra",                   "IT"),
    ("WIPRO.NS",       "Wipro",                           "IT"),
    ("TATAELXSI.NS",   "Tata Elxsi",                      "IT"),
    ("MPHASIS.NS",     "Mphasis",                         "IT"),
    ("PERSISTENT.NS",  "Persistent Systems",              "IT"),
    ("COFORGE.NS",     "Coforge",                         "IT"),
    ("KPITTECH.NS",    "KPIT Technologies",               "IT"),
    ("OFSS.NS",        "Oracle Financial Services",       "IT"),

    # ======== ENERGY / OIL & GAS / POWER ========
    ("RELIANCE.NS",    "Reliance Industries",             "Energy"),
    ("ONGC.NS",        "Oil & Natural Gas Corporation",   "Energy"),
    ("IOC.NS",         "Indian Oil Corporation",          "Energy"),
    ("BPCL.NS",        "Bharat Petroleum Corporation",    "Energy"),
    ("GAIL.NS",        "GAIL India",                      "Energy"),
    ("PETRONET.NS",    "Petronet LNG",                    "Energy"),
    ("NTPC.NS",        "NTPC",                            "Power"),
    ("POWERGRID.NS",   "Power Grid Corporation",          "Power"),
    ("TATAPOWER.NS",   "Tata Power Company",              "Power"),
    ("ADANIGREEN.NS",  "Adani Green Energy",              "Power"),
    ("ADANIPORTS.NS",  "Adani Ports and SEZ",             "Infrastructure"),
    ("ADANIENT.NS",    "Adani Enterprises",               "Conglomerate"),

    # ======== AUTOMOBILES ========
    ("MARUTI.NS",      "Maruti Suzuki India",             "Auto"),
    ("M&M.NS",         "Mahindra & Mahindra",             "Auto"),
    ("EICHERMOT.NS",   "Eicher Motors",                   "Auto"),
    ("BAJAJ-AUTO.NS",  "Bajaj Auto",                      "Auto"),
    ("ESCORTS.NS",     "Escorts Kubota",                  "Auto"),
    ("HEROMOTOCO.NS",  "Hero MotoCorp",                   "Auto"),
    ("ASHOKLEY.NS",    "Ashok Leyland",                   "Auto"),
    ("TVSMOTOR.NS",    "TVS Motor Company",               "Auto"),
    ("MRF.NS",         "MRF",                             "Auto"),
    ("APOLLOTYRE.NS",  "Apollo Tyres",                    "Auto"),

    # ======== METALS & MINING ========
    ("TATASTEEL.NS",   "Tata Steel",                      "Metals"),
    ("JSWSTEEL.NS",    "JSW Steel",                       "Metals"),
    ("HINDALCO.NS",    "Hindalco Industries",             "Metals"),
    ("COALINDIA.NS",   "Coal India",                      "Metals"),
    ("VEDL.NS",        "Vedanta",                         "Metals"),
    ("NMDC.NS",        "NMDC",                            "Metals"),
    ("SAIL.NS",        "Steel Authority of India",        "Metals"),
    ("HINDZINC.NS",    "Hindustan Zinc",                  "Metals"),
    ("NATIONALUM.NS",  "National Aluminium Company",      "Metals"),

    # ======== FMCG / CONSUMER STAPLES ========
    ("HINDUNILVR.NS",  "Hindustan Unilever",              "FMCG"),
    ("ITC.NS",         "ITC Limited",                     "FMCG"),
    ("NESTLEIND.NS",   "Nestle India",                    "FMCG"),
    ("BRITANNIA.NS",   "Britannia Industries",            "FMCG"),
    ("MARICO.NS",      "Marico",                          "FMCG"),
    ("DABUR.NS",       "Dabur India",                     "FMCG"),
    ("COLPAL.NS",      "Colgate-Palmolive India",         "FMCG"),
    ("TATACONSUM.NS",  "Tata Consumer Products",          "FMCG"),
    ("EMAMILTD.NS",    "Emami",                           "FMCG"),
    ("GODREJCP.NS",    "Godrej Consumer Products",        "FMCG"),

    # ======== PHARMA & HEALTHCARE ========
    ("SUNPHARMA.NS",   "Sun Pharmaceutical Industries",   "Pharma"),
    ("CIPLA.NS",       "Cipla",                           "Pharma"),
    ("DIVISLAB.NS",    "Divi's Laboratories",             "Pharma"),
    ("DRREDDY.NS",     "Dr. Reddy's Laboratories",        "Pharma"),
    ("LUPIN.NS",       "Lupin",                           "Pharma"),
    ("BIOCON.NS",      "Biocon",                          "Pharma"),
    ("TORNTPHARM.NS",  "Torrent Pharmaceuticals",         "Pharma"),
    ("AUROPHARMA.NS",  "Aurobindo Pharma",                "Pharma"),
    ("IPCALAB.NS",     "IPCA Laboratories",               "Pharma"),
    ("GLAXO.NS",       "GlaxoSmithKline Pharma India",    "Pharma"),
    ("APOLLOHOSP.NS",  "Apollo Hospitals Enterprise",     "Healthcare"),

    # ======== CONSUMER DISCRETIONARY / RETAIL ========
    ("DMART.NS",       "Avenue Supermarts (DMart)",       "Consumer"),
    ("TITAN.NS",       "Titan Company",                   "Consumer"),
    ("TRENT.NS",       "Trent",                           "Consumer"),
    ("JUBLFOOD.NS",    "Jubilant FoodWorks",              "Consumer"),
    ("PAGEIND.NS",     "Page Industries",                 "Consumer"),
    ("WESTLIFE.NS",    "Westlife Foodworld",              "Consumer"),
    ("VGUARD.NS",      "V-Guard Industries",              "Consumer"),

    # ======== NEW AGE / TECH PLATFORMS ========
    ("DELHIVERY.NS",   "Delhivery",                       "New Age Tech"),
    ("NYKAA.NS",       "Nykaa (FSN E-Commerce)",          "New Age Tech"),
    ("NAUKRI.NS",      "Info Edge (Naukri)",              "New Age Tech"),
    ("POLICYBZR.NS",   "PB Fintech (PolicyBazaar)",       "New Age Tech"),
    ("PAYTM.NS",       "Paytm (One97 Communications)",   "New Age Tech"),

    # ======== INFRASTRUCTURE / CAPITAL GOODS ========
    ("LT.NS",          "Larsen & Toubro",                 "Infrastructure"),
    ("BHEL.NS",        "Bharat Heavy Electricals",        "Capital Goods"),
    ("SIEMENS.NS",     "Siemens India",                   "Capital Goods"),
    ("ABB.NS",         "ABB India",                       "Capital Goods"),
    ("CUMMINSIND.NS",  "Cummins India",                   "Capital Goods"),
    ("THERMAX.NS",     "Thermax",                         "Capital Goods"),
    ("HAVELLS.NS",     "Havells India",                   "Capital Goods"),
    ("POLYCAB.NS",     "Polycab India",                   "Capital Goods"),
    ("KEI.NS",         "KEI Industries",                  "Capital Goods"),
    ("DIXON.NS",       "Dixon Technologies",              "Capital Goods"),
    ("VOLTAS.NS",      "Voltas",                          "Capital Goods"),
    ("ASTRAL.NS",      "Astral",                          "Capital Goods"),

    # ======== TELECOM ========
    ("BHARTIARTL.NS",  "Bharti Airtel",                   "Telecom"),
    ("INDUSTOWER.NS",  "Indus Towers",                    "Telecom"),
    ("TATACOMM.NS",    "Tata Communications",             "Telecom"),

    # ======== CEMENT ========
    ("ULTRACEMCO.NS",  "UltraTech Cement",                "Cement"),
    ("AMBUJACEM.NS",   "Ambuja Cements",                  "Cement"),
    ("ACC.NS",         "ACC",                             "Cement"),
    ("SHREECEM.NS",    "Shree Cement",                    "Cement"),
    ("DALBHARAT.NS",   "Dalmia Bharat",                   "Cement"),
    ("JKCEMENT.NS",    "JK Cement",                       "Cement"),
    ("RAMCOCEM.NS",    "Ramco Cements",                   "Cement"),

    # ======== REAL ESTATE ========
    ("DLF.NS",         "DLF",                             "Real Estate"),
    ("GODREJPROP.NS",  "Godrej Properties",               "Real Estate"),
    ("OBEROIRLTY.NS",  "Oberoi Realty",                   "Real Estate"),
    ("PRESTIGE.NS",    "Prestige Estates Projects",       "Real Estate"),

    # ======== CHEMICALS / SPECIALTY ========
    ("PIDILITIND.NS",  "Pidilite Industries",             "Chemicals"),
    ("SRF.NS",         "SRF",                             "Chemicals"),
    ("DEEPAKNTR.NS",   "Deepak Nitrite",                  "Chemicals"),
    ("VINATIORGA.NS",  "Vinati Organics",                 "Chemicals"),
    ("ATUL.NS",        "Atul",                            "Chemicals"),
    ("NAVINFLUOR.NS",  "Navin Fluorine International",    "Chemicals"),
    ("FINEORG.NS",     "Fine Organics Industries",        "Chemicals"),
    ("ALKYLAMINE.NS",  "Alkyl Amines Chemicals",          "Chemicals"),

    # ======== DEFENCE / PSU ========
    ("BEL.NS",         "Bharat Electronics",              "Defence"),
    ("HAL.NS",         "Hindustan Aeronautics",           "Defence"),
    ("IRCTC.NS",       "IRCTC",                           "PSU"),
    ("CONCOR.NS",      "Container Corporation of India",  "PSU"),
    ("NHPC.NS",        "NHPC",                            "PSU"),
    ("PFC.NS",         "Power Finance Corporation",       "PSU"),
    ("HUDCO.NS",       "Housing & Urban Development",     "PSU"),
]

# (AMFI scheme code, scheme name, category)
# Every code verified against mfapi.in (SUCCESS + positive NAV) at build time.
MARKET_FUNDS: list[tuple[str, str, str]] = [
    # ======== INDEX FUNDS ========
    ("120716", "UTI Nifty 50 Index Fund - Direct Growth",                   "Index"),
    ("119063", "HDFC Nifty 50 Index Fund - Direct Growth",                  "Index"),
    ("119065", "HDFC BSE Sensex Index Fund - Direct Growth",                "Index"),
    ("120684", "ICICI Pru Nifty Next 50 Index Fund - Direct Growth",       "Index"),
    ("143341", "UTI Nifty Next 50 Index Fund - Direct Growth",              "Index"),
    ("147625", "Motilal Oswal Nifty 500 Index Fund - Direct Growth",        "Index"),
    ("147622", "Motilal Oswal Nifty Midcap 150 Index Fund - Direct Growth", "Index"),
    ("147623", "Motilal Oswal Nifty Smallcap 250 Index Fund - Direct Growth","Index"),
    ("148726", "Nippon India Nifty Midcap 150 Index Fund - Direct Growth",  "Index"),
    ("151724", "HDFC Nifty Midcap 150 Index Fund - Direct Growth",          "Index"),

    # ======== LARGE CAP ========
    ("118825", "Mirae Asset Large Cap Fund - Direct Growth",                "Large Cap"),
    ("120586", "ICICI Pru Large Cap Fund - Direct Growth",                  "Large Cap"),
    ("120465", "Axis Large Cap Fund - Direct Growth",                       "Large Cap"),
    ("118632", "Nippon India Large Cap Fund - Direct Growth",               "Large Cap"),
    ("119598", "SBI Large Cap Fund - Direct Growth",                        "Large Cap"),
    ("118269", "Canara Robeco Large Cap Fund - Direct Growth",              "Large Cap"),

    # ======== FLEXI CAP ========
    ("122639", "Parag Parikh Flexi Cap Fund - Direct Growth",               "Flexi Cap"),
    ("118955", "HDFC Flexi Cap Fund - Direct Growth",                       "Flexi Cap"),
    ("120166", "Kotak Flexi Cap Fund - Direct Growth",                      "Flexi Cap"),
    ("119076", "DSP Flexi Cap Fund - Direct Growth",                        "Flexi Cap"),
    ("120843", "Quant Flexi Cap Fund - Direct Growth",                      "Flexi Cap"),

    # ======== LARGE & MID CAP ========
    ("147704", "Motilal Oswal Large and Midcap Fund - Direct Growth",       "Large & Mid Cap"),

    # ======== MID CAP ========
    ("147445", "Mirae Asset Midcap Fund - Direct Growth",                   "Mid Cap"),
    ("118989", "HDFC Mid Cap Opportunities Fund - Direct Growth",           "Mid Cap"),
    ("120505", "Axis Midcap Fund - Direct Growth",                          "Mid Cap"),
    ("140228", "Edelweiss Mid Cap Fund - Direct Growth",                    "Mid Cap"),
    ("125307", "PGIM India Midcap Opportunities Fund - Direct Growth",      "Mid Cap"),

    # ======== SMALL CAP ========
    ("118778", "Nippon India Small Cap Fund - Direct Growth",               "Small Cap"),
    ("125354", "Axis Small Cap Fund - Direct Growth",                       "Small Cap"),
    ("125497", "SBI Small Cap Fund - Direct Growth",                        "Small Cap"),
    ("120828", "Quant Small Cap Fund - Direct Growth",                      "Small Cap"),
    ("119212", "DSP Small Cap Fund - Direct Growth",                        "Small Cap"),
    ("120164", "Kotak Small Cap Fund - Direct Growth",                      "Small Cap"),
    ("146130", "Canara Robeco Small Cap Fund - Direct Growth",              "Small Cap"),
    ("129649", "Union Small Cap Fund - Direct Growth",                      "Small Cap"),

    # ======== ELSS (TAX SAVER) ========
    ("135781", "Mirae Asset ELSS Tax Saver Fund - Direct Growth",           "ELSS"),
    ("120847", "Quant ELSS Tax Saver Fund - Direct Growth",                 "ELSS"),
    ("118285", "Canara Robeco ELSS Tax Saver Fund - Direct Growth",         "ELSS"),

    # ======== HYBRID / BALANCED ADVANTAGE ========
    ("118968", "HDFC Balanced Advantage Fund - Direct Growth",              "Hybrid"),
    ("120377", "ICICI Prudential Balanced Advantage Fund - Direct Growth",  "Hybrid"),
    ("118736", "Nippon India Balanced Advantage Fund - Direct Growth",      "Hybrid"),
    ("134813", "Mirae Asset Aggressive Hybrid Fund - Direct Growth",        "Hybrid"),

    # ======== SECTORAL / THEMATIC ========
    ("120594", "ICICI Prudential Technology Fund - Direct Growth",          "Sectoral-IT"),
    ("120578", "SBI Technology Opportunities Fund - Direct Growth",         "Sectoral-IT"),
    ("143783", "Mirae Asset Healthcare Fund - Direct Growth",               "Sectoral-Health"),
    ("118759", "Nippon India Pharma Fund - Direct Growth",                  "Sectoral-Pharma"),
    ("118979", "HDFC Infrastructure Fund - Direct Growth",                  "Sectoral-Infra"),

    # ======== INTERNATIONAL ========
    ("148381", "Motilal Oswal S&P 500 Index Fund - Direct Growth",          "International"),
]
