# toolbox
Useful little tools

### AWS Related
- **ec2-create.sh** - create ec2 instance
- **ec2-list.py** - list ec2 by tag prefix and running state
- **s3-upload-with-multipart-off.sh** - s3 put object with multipart off (`aws s3 cp` makes it on by default)

> To run shell scripts above, you need `awscli` installed and configured:
> ```
> $ brew install awscli
> $ aws configure
> ```
> To run python scripts above, you need `boto3` additionally:
> ```
> $ sudo easy_install pip
> $ sudo -H pip install boto3 --ignore-installed six
> ```

### Git Related
- **git-author.sh** - change author info in existing git commits
