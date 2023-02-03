import os
import time
import shutil
import tempfile

if __name__ == "__main__":
    suffix = time.strftime("%Y_%m_%d_%H_%M_%S")
    tmp_dir = tempfile.gettempdir()
    tmp_path = os.path.join(tmp_dir, f"tmp_dotstutor.{suffix}")
    shutil.copyfile("../dotstutor", tmp_path)
    os.system(f"nvim {tmp_path}")
    os.remove(tmp_path)
