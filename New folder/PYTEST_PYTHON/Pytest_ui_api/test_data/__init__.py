from config.config import Config


class TestData:
    VALID_USER = {
        "email": Config.VALID_EMAIL,
        "password": Config.VALID_PASSWORD,
    }
    PREMIUM_USER = {
        "email": Config.PREMIUM_EMAIL,
        "password": Config.PREMIUM_PASSWORD,
    }
    INVALID_USER = {
        "email": Config.INVALID_EMAIL,
        "password": Config.INVALID_PASSWORD,
    }

    SEARCH_KEYWORDS_VALID = ["cricket", "avengers", "family man", "ipl", "kbc"]
    SEARCH_KEYWORDS_NO_RESULT = ["xyznotexist123", "aaabbbcccqqq"]
    SEARCH_SPECIAL_CHARS = ["@#$%", "----", "   "]

    CONTENT = {
        "movie_title": Config.MOVIE_TITLE,
        "series_title": Config.SERIES_TITLE,
        "live_channel": Config.LIVE_CHANNEL,
        "search_keyword": Config.SEARCH_KEYWORD,
        "free_content_id": Config.FREE_CONTENT_ID,
        "premium_content_id": Config.PREMIUM_CONTENT_ID,
    }

    SUBSCRIPTION_PLANS = ["Super", "Premium"]
    INVALID_COUPON = "FAKECOUPON999"
