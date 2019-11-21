diff <(ls img | sort) <(cat imgs.txt | while read i; do basename $i; done | sort)
