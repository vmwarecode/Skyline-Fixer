param(
 [string]$CSVFILE
)




#MAIN PROG
import-csv $CSVFILE | foreach-object {

$KB = $_."Reference"
$VCENTER = $_."Source Name"
$ESX = $_."Object Name"

 switch ($KB ) {
 "https://kb.vmware.com/s/article/1003736" {
        connect-viserver -server $VCENTER

	add-vmhostntpserver -vmhost $ESX -ntpserver 0.north-america.pool.ntp.org

	get-vmhost -name $ESX | get-vmhostservice | where-object {$_.key -eq "ntpd" } | start-vmhostservice
	get-vmhost -name $ESX | get-vmhostservice | where-object {$_.key -eq "ntpd" } | set-vmhostservice -policy "automatic"

        disconnect-viserver -confirm:$false
        } #1003736

 "https://kb.vmware.com/s/article/2003322" {
	connect-viserver -server $VCENTER
	
	get-advancedsetting -entity $ESX -name "Syslog.global.logDir" | set-advancedsetting -value "[datastore1] /" -confirm:$false
	get-advancedsetting -entity $ESX -name "Syslog.global.logDirUnique" | set-advancedsetting -value $true -confirm:$false
	get-advancedsetting -entity $ESX -name "Syslog.global.logHost" | set-advancedsetting -value "udp://192.168.222.100:514" -confirm:$false

	disconnect-viserver -confirm:$false
 	} #2003322

 } #switch
 
} #import