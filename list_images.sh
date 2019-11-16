kubectl get pods -A -o jsonpath='{ range .items[*].spec.containers[*] }{ .image }{ "\n" }{ end }' | sort | uniq > imgs.txt
