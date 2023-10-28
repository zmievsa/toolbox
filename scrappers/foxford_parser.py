# wkhtmltopdf is required (install through apt)
import os
import os.path

import pdfkit
import requests

SECTIONS_URL = "https://foxford.ru/wiki/api/sections?discipline_id=6&grade_id=6"
THEME_URL_TEMPLATE = "https://foxford.ru/wiki/obschestvoznanie/{translit_name}"


def main():
    """Used to download books from foxford"""
    sections = requests.get(SECTIONS_URL).json()
    for section in sections:
        os.makedirs(section["name"], exist_ok=True)
        for counter, theme in enumerate(section["themes"], start=1):
            output_name = "{}) {}.pdf".format(counter, theme["name"])
            output_path = os.path.join(section["name"], output_name)
            theme_url = THEME_URL_TEMPLATE.format(translit_name=theme["translit_name"])
            if not os.path.exists(output_path):
                pdfkit.from_url(theme_url, output_path)


if __name__ == "__main__":
    main()
