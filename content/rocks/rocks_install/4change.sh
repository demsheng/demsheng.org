#!/bin/bash

restartSge_execd()
{
    /etc/init.d/sgemaster.sandbox stop
    /etc/init.d/sgemaster.sandbox start
    for i in {3..13}
    do
        ssh node$i "/etc/init.d/sgeexecd.sandbox stop"
        ssh node$i "/etc/init.d/sgeexecd.sandbox start"
    done
    ssh node1 "/etc/init.d/sgeexecd.sandbox stop"
    ssh node0 "/etc/init.d/sgeexecd.sandbox start"
}

restartSge_execd


