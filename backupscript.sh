# the purpose is to backup specific directories
# features --> delte old backups, logging, error detection

backup_directoy="/etc/systemd/system/user"
external_server="192.168.0.12"
destination_directory="/home/student2/Documents




for file in "$backup_directory"/*
do 
	if [ -f "$file" ]; then
		rsync -avz "$file" root@"external_server":"$destination_directory"
	else
		echo "error encounted"
	fi
done

#schedule the job
(corntab -l ; echo "0 9 * * * $(realpath "$0")") | crontab - 

