import os
import time
import shutil

if __name__ == "__main__":
    suffix = time.strftime("%Y_%m_%d_%H_%M_%S")
    cwd = os.path.dirname(os.path.realpath(__file__))
    dotstutor_path = os.path.join(cwd, "..", "dotstutor")
    tmp_path = os.path.join(cwd, "..", f"tmp_dotstutor.{suffix}")
    shutil.copyfile(dotstutor_path, tmp_path)
    os.system(f"nvim {tmp_path}")
    os.remove(tmp_path)
