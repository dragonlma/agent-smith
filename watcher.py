import os,sys,traceback
from inotify_simple import INotify, flags
import subprocess

THIS = os.path.basename(__file__)
DIRPATH = sys.argv[1]
BASEPATH = sys.argv[2]
TENANT = "agent-smith"

if not os.path.exists(BASEPATH):
    BASEPATH="http://localhost:8080/"

if not os.path.exists(DIRPATH):
    print "Error: missing path parameter\nUsage: python %s <dir-to-watch> [path-to-cms]\n" % THIS
    sys.exit(1)

print "THIS:%s, DIRPATH:%s, BASEPATH:%s, TENANT:%s" % (THIS, DIRPATH, BASEPATH,TENANT)

#https://github.com/hosom/python-mandrake/blob/master/inotify/inotify_simple.py
inotify = INotify()
watch_flags = flags.CLOSE_WRITE
wd = inotify.add_watch(DIRPATH, watch_flags)

while True:
    try:
        for event in inotify.read():
            print(event)
            file = event.name
            FILECHANGE = DIRPATH+"/"+file
            print "Publishing file:[",FILECHANGE,"], - tenant:[",TENANT,"], - channel:[",FILECHANGE,"], file[",file,"]"
            URL = BASEPATH+"pubsub?tenant="+TENANT+"&channel="+file
            command = "curl -s -S -m 1 -X POST \"%s\" --data \"`cat %s`\" > /dev/null" % (URL, FILECHANGE)
            print command
            subprocess.call(command, shell=True)
    except:
        print "Exception in user code:"
        traceback.print_exc(file=sys.stdout)

