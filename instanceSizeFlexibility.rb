#!/usr/bin/env ruby

# Copyright (c) 2018 iAchieved.it LLC
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'bundler/setup'
require 'aws-sdk-ec2'

# See https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/apply_ri.html
normalizationFactors = {
'nano':     0.25,
'micro':    0.5,
'small':    1,
'medium':   2,
'large':    4,
'xlarge':   8,
'2xlarge':  16,
'4xlarge':  32,
'8xlarge':  64,
'9xlarge':  72,
'10xlarge': 80,
'12xlarge': 96,
'16xlarge': 128,
'18xlarge': 144,
'24xlarge': 192,
'32xlarge': 256
}

# Accurate as of December 2018
# See https://aws.amazon.com/ec2/instance-types/ for up-to-date
# types.
validSizes = {
  't2':  ['nano',  'micro',  'small',   'medium',  'large', 'xlarge', '2xlarge'],
  't3':  ['nano',  'micro',  'small',   'medium',  'large', 'xlarge', '2xlarge'],
  'm4':  ['large', 'xlarge', '2xlarge', '4xlarge', '10xlarge'],
  'm5':  ['large', 'xlarge', '2xlarge', '4xlarge', '12xlarge', '24xlarge'],
  'm5a': ['large', 'xlarge', '2xlarge', '4xlarge', '12xlarge', '24xlarge'],
  'm5d': ['large', 'xlarge', '2xlarge', '4xlarge', '12xlarge', '24xlarge'],
  'c4':  ['large', 'xlarge', '2xlarge', '4xlarge', '8xlarge'],
  'c5':  ['large', 'xlarge', '2xlarge', '4xlarge', '9xlarge',  '18xlarge'],
  'c5d': ['large', 'xlarge', '2xlarge', '4xlarge', '9xlarge',  '18xlarge'],
  'c5n': ['large', 'xlarge', '2xlarge', '4xlarge', '9xlarge',  '18xlarge'],
  'r5':  ['large', 'xlarge', '2xlarge', '4xlarge', '12xlarge', '24xlarge'],
  'r5d': ['large', 'xlarge', '2xlarge', '4xlarge', '12xlarge', '24xlarge'],  
  'r5a': ['large', 'xlarge', '2xlarge', '4xlarge', '12xlarge', '24xlarge'],  
  'r4':  ['large', 'xlarge', '2xlarge', '4xlarge', '8xlarge',  '16xlarge']
}

# Retrieve our instances
ec2 = Aws::EC2::Resource.new(region: ARGV[0] || 'us-east-2')
      
# Organize our instances
instances = Hash.new
ec2.instances.each do |i|
  next if i.platform == 'windows' # Windows instances are not eligibile
  class_, size = "#{i.instance_type}".split('.')
  if not instances.has_key? class_ then
  	instances[class_] = []
  end
  instances[class_].push(size)
end

# Determine how many 'small'-equivalent instances we have
# of each class
allocation = Hash.new
instances.keys.each do |k|
  instances[k].each do |i|
	if not allocation.has_key? k then
	  allocation[k] = 0.0
	end
	allocation[k] += normalizationFactors[i.to_sym].to_f
  end
end

# allocation now contains the number of 'small' instances
# Generate a table of equivalence for the various sizes
puts "Class,Size,Count"
normalizationFactors.each do |sk, sv|
	allocation.each do |ak, av|
    if validSizes[ak.to_sym].include? sk.to_s
  		n = (av * (1.0 / sv)).floor
	 	  puts "#{ak},#{sk},#{n}"
    end
	end
end	
