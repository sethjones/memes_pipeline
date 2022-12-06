#!/bin/bash

directory=''
files=''

print_usage() {
  printf "Usage: ..."
}

while getopts ':d:f:' flag; do
  case "${flag}" in
  d) directory="${OPTARG}" ;;
  f) files="${OPTARG}" ;;
  *)
    print_usage
    exit 1
    ;;
  esac
done

if ! [ -z "$directory"]; then
  phashes="${directory}-phashes.txt"
  diffs="${directory}-diffs.json"
  printf "Calculating phashes for ${directory}..."
  time python calculate_phashes.py --directory $directory --output $phashes
  printf "Calculating pairwise comparisons..."
  time python pairwise_comparisons.py -d 0 --input $phashes --output $diffs
else
  phashes=$files
  diffs=$phashes-diffs.json
  printf "Calculating pairwise comparisons..."
  time python pairwise_comparisons.py --input $files --device 0
fi

printf "Clustering pairwise..."
time python clustering_phashes.py --phashes $phashes --distances $diffs --output $phashes-clustering_output.txt --matrix $phashes-distance_matrix.mat --index $phashes-index.p

printf "Visualize Clusters..."
time python visualize_clusters.py -c $phashes-clustering_output.txt -m $phashes-distance_matrix.mat -i $phashes-index.p --output clusters_visualization-$phashes 

printf "Annotate via KYM ..."
time python annotate_via_kym.py --phashes $phashes --clustering $phashes-clustering_output.txt
