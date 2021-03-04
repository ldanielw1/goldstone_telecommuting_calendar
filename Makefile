clean:
	-@make clean_temp_files > /dev/null 2> /dev/null

clean_temp_files:
	-@rm .*~ *~ \#* .DS_Store *.log 2> /dev/null > /dev/null
	-@for dir in `ls -F | grep -v //$ | grep -v "^tmp" | grep /$ | cut -d/ -f1`; do cd $$dir; cp ../Makefile .; make clean; rm Makefile; cd .. ;done 2> /dev/null > /dev/null

server:
	-@rake db:drop db:create db:migrate db:seed
	-@make clean >/dev/null 2>/dev/null
