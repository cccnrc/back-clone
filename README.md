# Back Clone

Back<sub>(up/ground)</sub> Clone: a task manager to backup your local directories to Google Cloud
---
## Overview
This is a simple task manager that you can use to save your local directories to [Google Cloud](https://cloud.google.com/), and keep them update
It is based on [rclone](https://rclone.org/drive/)


---
## Prerequisites

1. install [rclone](https://rclone.org/drive/)
```
curl https://rclone.org/install.sh | sudo bash
```
- ***note***: this refers to Linux, for other OS please take a look at [rclone installation instructions](https://rclone.org/install/)

2. setup [rclone](https://rclone.org/drive/) for your Google Cloud account: [howtogeek guide](https://www.howtogeek.com/451262/how-to-use-rclone-to-back-up-to-google-drive-on-linux)
as simple as:
```
rclone config
```
---
## Installation

Just clone [back-clone](https://github.com/cccnrc/back-clone) and make scripts executable:
```
git clone https://github.com/cccnrc/back-clone.git
chmod +x ./script/*
```

---
## Usage
You can choose two different ways to use [back-clone](https://github.com/cccnrc/back-clone):
1. [single folder backup](https://github.com/cccnrc/back-clone#1-single-folder-backup)
2. [multiple folders backup](https://github.com/cccnrc/back-clone#2-multiple-folders-backup)

***note***: to use [back-clone](https://github.com/cccnrc/back-clone) you need to be inside the directory you cloned from this repository:
```
cd back-clone
```

### 1. single folder backup
Just call the script with necessary arguments (see below):
```
./script/rclone-check-PID-launch.sh \
    $LOCAL_DIR \
    $CLOUD_DIR \
    $PROCESS_NAME
```
#### 1.1. `LOCAL_DIR`
you have to set this to the path of the local directory you want to backup. As example:
```
LOCAL_DIR=/home/your-username/directory-to-backup
```
#### 1.2. `CLOUD_DIR`
this must be set to the ***whole path*** of the cloud directory, it looks like this:
> cloud-name:directory-path

- ***cloud-name***: corresponds to the `name` you set during `rclone config`
- ***directory-path***: corresponds to the pathway of the directory you want to store the files in on cloud. It will create all directories specified if they do not exists, and store all files ***inside*** `LOCAL_DIR` into that directory (it won't copy `LOCAL_DIR` as well, but only all files in it)

#### 1.3. `PROCESS_NAME`
this is ***optional*** and it is used to store the logs of this backup. If you set it you will find all logs in a file created inside this [logs/](logs) directory using `PROCESS_NAME`: `$PROCESS_NAME.back-clone.log`
If not set, it will use the name (not the full path) of `LOCAL_DIR` as `PROCESS_NAME`

<br/>
<br/>

### 2. multiple folders backup
You can create a [TSV file](https://en.wikipedia.org/wiki/Tab-separated_values) with all the directories you want to backup and the relative pathways (and relative `PROCESS_NAME` if you wish). Then launch it with:
```
./script/rclone-launcher.sh $INPUT_TSV
```
***note***: this file must contain a specific header of which you find a copy in [input/process.tsv-HEADER](input/process.tsv-HEADER) and for each folder you have to specify:
- `LOCAL_DIR`: at column 1
- `CLOUD_DIR`: at column 2
- `PROCESS_NAME`: at column 3 (optional)
the script will launch the backup for each folder and store logs into [logs/](logs) with the name of the `$INPUT_TSV` file (removing `.tsv` extension)
