import os
import shutil

def move_files_to_root(root_dir):
    root_dir = os.path.abspath(root_dir)
    print(f"Moving files to: {root_dir}")

    for dirpath, dirnames, filenames in os.walk(root_dir, topdown=False):
        if dirpath == root_dir:
            continue  # Skip root itself

        for filename in filenames:
            src_file = os.path.join(dirpath, filename)
            dst_file = os.path.join(root_dir, filename)

            if os.path.exists(dst_file):
                print(f"Skipping (already exists): {dst_file}")
                continue

            print(f"Moving: {src_file} -> {dst_file}")
            shutil.move(src_file, dst_file)

        # Remove empty directory if possible
        try:
            os.rmdir(dirpath)
        except OSError:
            pass  # Directory not empty or can't be removed

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print("Usage: python move_files.py <directory>")
    else:
        move_files_to_root(sys.argv[1])
