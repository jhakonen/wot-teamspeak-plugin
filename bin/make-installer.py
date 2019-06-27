import glob
import os
import sys
import shutil
import zipfile

INSTALLER_PATH   = sys.argv[1]
TEMP_DIR_PATH    = sys.argv[2]
PACKAGE_INI_PATH = sys.argv[3]
PLUGIN_FILE_PATH = sys.argv[4]
OTHER_FILE_PATHS = sys.argv[5:]

if os.path.exists(TEMP_DIR_PATH):
	shutil.rmtree(TEMP_DIR_PATH)

os.makedirs(os.path.join(TEMP_DIR_PATH, 'plugins', 'tessumod_plugin'))

shutil.copyfile(PACKAGE_INI_PATH, os.path.join(TEMP_DIR_PATH, os.path.basename(PACKAGE_INI_PATH)))
shutil.copyfile(PLUGIN_FILE_PATH, os.path.join(TEMP_DIR_PATH, 'plugins', os.path.basename(PLUGIN_FILE_PATH)))
for entry in OTHER_FILE_PATHS:
	for file_path in glob.glob(entry):
		shutil.copyfile(file_path, os.path.join(TEMP_DIR_PATH, 'plugins', 'tessumod_plugin', os.path.basename(file_path)))

with zipfile.ZipFile(INSTALLER_PATH, 'w', zipfile.ZIP_DEFLATED) as installer_file:
	for dirpath, dirnames, filenames in os.walk(TEMP_DIR_PATH):
		for filename in filenames:
			input_filepath = os.path.join(dirpath, filename)
			in_archive_filepath = input_filepath.replace(TEMP_DIR_PATH, '').strip(os.sep)
			installer_file.write(input_filepath, in_archive_filepath)

shutil.rmtree(TEMP_DIR_PATH)
