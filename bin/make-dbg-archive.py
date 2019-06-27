import os
import sys
import zipfile

ARCHIVE_PATH = sys.argv[1]
INPUT_FILES = sys.argv[2:]

with zipfile.ZipFile(ARCHIVE_PATH, 'w', zipfile.ZIP_DEFLATED) as archive_file:
	for input_file_path in INPUT_FILES:
		archive_file.write(input_file_path, os.path.basename(input_file_path))
