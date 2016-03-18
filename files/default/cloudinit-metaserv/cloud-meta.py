#!/usr/bin/python
#
import uuid
from os import listdir, path
from bottle import route, run

# get_sshpubkeys Retrieves the contents of authorized_keys files \ 
# from all home directories except of user mctadmin
def get_sshpubkeys():
	sshpubkeys = [];
	homeroot = '/home/'
	homedirs = [ f for f in listdir(homeroot) if(f != 'mctadmin')]
	for userdir in homedirs:
		keypath = homeroot + userdir + "/.ssh/authorized_keys"
		if path.isfile(keypath):
			keyfile = open(keypath, 'r')
			for line in keyfile:
				if not line.startswith('#'):
					sshpubkeys.append(line)
		
			keyfile.close()
	return sshpubkeys


# get_metadata_list returns the list of metafiles the client can retrieve
def get_metadata_list():
	return '''
instance-id
public-keys
'''

# get_metadata_item returns the metadata contents the client requested
def get_metadata_item(name):
        if name == 'instance-id':
        	# generate a uuid on the fly
                return str(uuid.uuid4())

        elif name == 'public-keys':
                return get_sshpubkeys()


### Bottle HTTP Endpoints ##
# metadata list
@route('/latest/meta-data')  
@route('/latest/meta-data/') #ubuntu
@route('//latest/meta-data/') #centos6
def return_metadata_list():
	return get_metadata_list()
	
# metadata item
@route('/latest/meta-data/<item>')
@route('//latest/meta-data/<item>') #centos6
def return_metadata(item):
	return get_metadata_item(item)

run(host='0.0.0.0', port=80, debug=True)
