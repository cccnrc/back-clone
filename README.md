# Back Clone

Back<sub>(up/ground)</sub> Clone: a task manager to backup your local directories to Google Cloud
---
## Overview
This is a simple task manager that you can use to save your local directories to [Google Cloud](https://cloud.google.com/), and keep them update, with a single line command :sunglasses:

It is based on [rclone](https://rclone.org/drive/)


---
## Prerequisites

1. install [rclone](https://rclone.org/drive/)
```
curl https://rclone.org/install.sh | sudo bash
```
- ***note***: this refers to Linux, for other OS please take a look at [rclone installation instructions](https://rclone.org/install/)

2. setup [rclone](https://rclone.org/drive/) for your Google Cloud account: [howtogeek guide](https://www.howtogeek.com/451262/how-to-use-rclone-to-back-up-to-google-drive-on-linux).

As simple as:
```
rclone config
```
---
## Installation

Just clone [back-clone](https://github.com/cccnrc/back-clone) and make scripts executable:
```
git clone https://github.com/cccnrc/back-clone.git
cd ./back-clone
chmod +x ./script/*
```
you can also test it:
```
./script/rclone-launcher.sh test
```
(you'll know it if it works :wink:)

---
## Usage
You can choose two different ways to use [back-clone](https://github.com/cccnrc/back-clone):
1. [single folder backup](https://github.com/cccnrc/back-clone#1-single-folder-backup)
2. [multiple folders backup](https://github.com/cccnrc/back-clone#2-multiple-folders-backup)

***note***: to call [back-clone](https://github.com/cccnrc/back-clone) [scripts](script) you have **several solutions**: [take a look](https://github.com/cccnrc/back-clone#command) :wink:

### 1. single folder backup
Just call the script with necessary arguments (see [below](https://github.com/cccnrc/back-clone#11-local_dir)):
```
./script/rclone-check-PID-launch.sh \
    $LOCAL_DIR \
    $CLOUD_DIR \
    $PROCESS_NAME
```
***note***: this command returns the PID of the job

#### 1.1. `LOCAL_DIR`
you have to set this to the path of the local directory you want to backup. As example:
```
LOCAL_DIR=/home/your-username/directory-to-backup
```
#### 1.2. `CLOUD_DIR`
this must be set to the ***whole path*** of the cloud directory, it looks like this:
> cloud-name:directory-path

- ***cloud-name***: corresponds to the `name` you set during `rclone config`
- ***directory-path***: corresponds to the pathway of the directory you want to store the files in on cloud. It will **create** all directories specified if they do not exists, and store all files ***inside*** `LOCAL_DIR` into that directory (it won't copy `LOCAL_DIR` as well, but **only all files** in it)

#### 1.3. `PROCESS_NAME`
this is ***optional*** and it is used to store the logs of this backup. If you set it you will find all logs in a file created inside this [logs/](logs) directory using `PROCESS_NAME`: `$PROCESS_NAME.back-clone.log`
If not set, it will use the name (not the full path) of `LOCAL_DIR` as `PROCESS_NAME`


### 2. multiple folders backup
You can create a [TSV file](https://en.wikipedia.org/wiki/Tab-separated_values) with all the directories you want to backup and the relative pathways (and relative `PROCESS_NAME` if you wish). Then launch it with:
```
./script/rclone-launcher.sh $INPUT_TSV
```
***note***: this file must contain a specific header of which you find a copy in [input/process.tsv-HEADER](input/process.tsv-HEADER) and for each folder you have to specify:
- `LOCAL_DIR`: at column 1
- `CLOUD_DIR`: at column 2
- `PROCESS_NAME`: at column 3 (optional)
the script will launch the backup for each folder and store logs into [logs/](logs) with the name of the `$INPUT_TSV` file (removing `.tsv` extension). As example, if your `INPUT_TSV` file is called `folders-backup.tsv` you will find logs into `logs/folders-backup.log`. Moreover, any single backup will have its logs into `logs/PROCESS_NAME.log`

---
## Command
As for any script, you can use multiple choices to run it:

### 1. local launch
As said, to use [back-clone](https://github.com/cccnrc/back-clone) scripts, you can be inside the cloned repository directory and executes them as:
```
./script/rclone-launcher.sh
./script/rclone-check-PID-launch.sh
```

### 2. external launch
You can also refers to the absolute path of the scripts from another directory. Let's say you cloned the repo inside you `/home` folder:
```
/home/back-clone/script/rclone-launcher.sh
/home/back-clone/script/rclone-check-PID-launch.sh
```

### 3. store it in PATH
If you add the `script` directory path to your `$PATH` environment variable, it will automatically find them, and you can call it simply with `rclone-launcher.sh`. As example:
```
echo "export PATH=$PATH:/home/enrico/back-clone/script" >> ~/.bashrc
source ~/.bashrc
rclone-launcher.sh test
```
***note***: the above solution stores this into your `~/.bashrc` file, so it will be valid for any other terminal window you open from now on :sunglasses:

---
## Update
You can easily use [back-clone](https://github.com/cccnrc/back-clone) to keep your backups updated. As example, you can store the command to backup a folder into your `./bashrc` file: anytime a new terminal window is open it will update that folder :wink:
```
echo "/home/back-clone/script/rclone-launcher $INPUT_TSV" >> ~/.bashrc
```
You can also set a [crontab job](https://www.cyberciti.biz/faq/how-do-i-add-jobs-to-cron-under-linux-or-unix-oses/) to be executed every day, or hour etc.

There are **bilions** of other possibilities, ***explore them***! :rocket: (and let us now when you find a nice one :smile:)

---
## Overlaps
Don't worry about overlaps, through the ***PID manager*** (a file called `rclone-PID-map.tsv` you'll find inside [logs](logs) once you started your first backup) [back-clone](https://github.com/cccnrc/back-clone) checks if the previous job (with the same `PROCESS_NAME` is terminated, if not you will find the `PID` which is running the job with a `(running)` flag) :sunglasses:

---
### Closure
This is all for the moment, hope it was simple and exhaustive. :smile:

Please be sure to ***share*** with us any nice change you make to our [back-clone scripts](script), as example creating a [pull request](https://opensource.com/article/19/7/create-pull-request-github) to [back-clone](https://github.com/cccnrc/back-clone) repository.

We would love to ***incorporate*** them! :heart_eyes:
