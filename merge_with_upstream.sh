git fetch upstream
git checkout master
git merge upstream/master
git push 2>&1|grep "Everything up-to-date"
if [ $? != 0 ]; then
	make clean
	autoreconf -f -i
	./configure --disable-silent-rules
	make -j4
	cp ./src/.libs/* ./file-tests

	cd file-tests
	rm -rf .mgc_temp
	rm -rf .Magdir
	cp -R ../magic/Magdir .
	LD_LIBRARY_PATH=. python ./update-db.py file-trunk Magdir ./lt-file
fi
