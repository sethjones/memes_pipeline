#!/bin/bash

files=''

print_usage() {
  printf "Usage: ..."
}

while getopts 'f:' flag; do
  case "${flag}" in
    f) files="${OPTARG}" ;;
    *) print_usage
       exit 1 ;;
  esac
done

printf "Calculating pairwise comparisons..."
python pairwise_comparisons.py --input $files -d 0

# printf "Clustering pairwise..."
# python clustering_phashes.py 

# printf "Visualize Clusters..."
# python visualize_clusters.py 

# printf "Annotate via KYM ..."
# python annotate_via_kym.py --phashes $files
