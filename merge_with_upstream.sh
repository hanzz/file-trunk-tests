git fetch upstream
git checkout master
git merge -s ours upstream/master 2>&1|grep "Already up-to-date."
RET=$?
git diff -R upstream/master src/ magic/ > x.patch
patch -p1 < x.patch
git add ./magic/Magdir/*
git commit -a -m 'merge with upstream'

grep diff x.patch
RET2=$?
echo "RET=$RET, RET2=$RET2"
if [ $RET != 0 -o $RET2 != 1 ]; then
	git push
	make clean
	autoreconf -f -i
	./configure --disable-silent-rules
	make -j4
	cp ./src/.libs/* ./file-tests

	cd file-tests
	rm -rf .mgc_temp
	rm -rf ./Magdir
	cp -R ../magic/Magdir .
	git rm db/*/*.pickle
	LD_LIBRARY_PATH=. python ./update-db.py file-trunk Magdir ./lt-file
	git add db/*/*.pickle
	git commit -a -m "Automatic database update"
fi
