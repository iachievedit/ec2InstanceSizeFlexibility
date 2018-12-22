# Instance Size Flexibility

<b>Instance Size Flexbility</b> is a feature of certain <a href="">reserved instances</a> in AWS.

This repository is a companion to <a href="https://dev.iachieved.it/iachievedit/leveraging-instance-size-flexibility-with-ec2-reserved-instances/">Leveraging Instance Size Flexibility with EC2 Reserved Instances</a>.

## Using this code

<a href="https://bundler.io/">Bundler</a> is required.

```
bundle install --path vendor/bundle
```

Run as:

```
./instanceSizeFlexibility.rb [REGION]
```

`REGION` will default to `us-east-2` (US East Ohio).

For example, to query your instances in US West Oregon:

```
./instanceSizeFlexibility.rb us-west-2
```

The output of this script is instance size flexibility equivalences for the instances you currently have.  For example,

```
./instanceSizeFlexibility.rb us-west-2
Class,Size,Count
t2,nano,160
t3,nano,24
t2,micro,80
t3,micro,12
t2,small,40
t3,small,6
t2,medium,20
t3,medium,3
t2,large,10
t3,large,1
t2,xlarge,5
t3,xlarge,0
m5,xlarge,1
t2,2xlarge,2
t3,2xlarge,0
```

Using the output above, the following purchasing decisions could be made:

* purchase either 160 t2.nano, 80 t2.micro, 40 t2.small, 20 t2.medium, 10 t2.large, 5 t2.xlarge, <i>or</i> 2 t2.2xlarge reserved instances
* purchase either 24 t3.nano, 12 t3.micro, 6 t3.small, 3 t3.medium, <i>or</i> 1 t3.large reserved instances

<b>Note</b>:  This script does not take into account reserved instances <i>already purchased</i>, but shows only the maximum number of instances that could potentially be purchased to provide 100% coverage.

---
This `README.md` was written with <a href="https://macdown.uranusjr.com">MacDown</a>, our favorite Markdown editor.

