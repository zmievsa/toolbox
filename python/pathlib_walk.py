import os
from pathlib import Path
from typing import Callable, Generator, List, Optional, Tuple, Union


def pathwalk(
    top: Union[str, Path],
    topdown: bool = True,
    onerror: Optional[Callable[[OSError], None]] = None,
    followlinks: bool = False,
) -> Generator[Tuple[Path, List[Path], List[Path]], None, None]:
    for root, dirs, files in os.walk(top, topdown, onerror, followlinks):
        yield Path(root), [Path(root, d) for d in dirs], [Path(root, f) for f in files]
