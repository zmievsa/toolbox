import os.path
from os import makedirs

import requests
from bs4 import BeautifulSoup

CHAPTERS = ["1", "10", "11", "12", "13", "14", "15"]  # for easy configuration
CHAPTERS_URL = "http://calcchat.com/xml/calc_8e_chapters.xml"
EXERCISE_DOWNLOAD_URL = "http://c811114.r14.cf2.rackcdn.com/{section_pre}{ex_id}.gif"


def main(chapters_to_download):
    """Used to download answers from calcchat"""
    print("Began execution")  # print is used for simplicity
    chapters = BeautifulSoup(
        requests.get(CHAPTERS_URL).content, "html.parser"
    ).find_all("chapter")
    chapters = [Chapter(c) for c in chapters if c.get("name") in chapters_to_download]
    for chapter in chapters:
        print("Downloading chapter " + chapter.name)
        chapter_dir = "Chapter " + chapter.name
        for section in chapter.sections:
            print("Downloading section " + section.name)
            section_dir = os.path.join(chapter_dir, "Section " + section.name)
            makedirs(section_dir, exist_ok=True)
            for exercise_id in range(1, section.final_exercise + 1, 2):
                exercise_path = os.path.join(section_dir, str(exercise_id) + ".gif")
                if not os.path.exists(exercise_path):
                    print("Downloading exercise " + str(exercise_id))
                    exercise = download_exercise(exercise_id, section)
                    save_file(exercise, exercise_path)


class Chapter:
    def __init__(self, xml):
        self.name = xml.get("name")
        self.sections = [Section(s) for s in xml.find_all("section")]


class Section:
    def __init__(self, xml):
        self.name = xml.get("name")
        self.pre = xml.get("pre")
        self.final_exercise = int(xml.get("num_ex"))


def download_exercise(exercise_id, section):
    url = EXERCISE_DOWNLOAD_URL.format(
        section_pre=section.pre, ex_id=format_as_hundread(exercise_id)
    )
    response = requests.get(url)
    while response.status_code != 200:
        response = requests.get(url)
    return response.iter_content(chunk_size=1024)


def format_as_hundread(exercise_id: int) -> str:
    if exercise_id < 10:
        return "00" + str(exercise_id)
    elif exercise_id < 100:
        return "0" + str(exercise_id)
    elif exercise_id < 1000:
        return str(exercise_id)
    else:
        raise ValueError("Something's wrong. Ex_id:" + str(exercise_id))


def save_file(content, path):
    with open(path, "wb") as f:
        for chunk in content:
            if chunk:  # filter out keep-alive new chunks
                f.write(chunk)


if __name__ == "__main__":
    main(CHAPTERS)
