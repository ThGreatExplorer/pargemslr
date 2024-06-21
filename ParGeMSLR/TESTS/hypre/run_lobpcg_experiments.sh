#!/bin/bash

usage() {
	echo "Usage: ./run_experiments [Solver_ID] [Grid Size] [Max Iterations] [Number of Runs]"
	echo "Run's LOBPCG a set number of times with various supported solvers on a 3d Grid Laplacian of a given sizes" 
	echo ""
	echo "Options:"
	echo "  -h, --help       Show this help message and exit."
	echo "  -na --no-auto    Does not automatically click thru."
}

# Check if '-h' or '--help' flags are passed
if [[ "$1" == "-h" || "$1" == "--help" || "$2" == "-h" || "$2" == "--help" ]]; then
    usage
    exit 0
fi

# Ensure a arguments are provided
if [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]]; then
    echo "Error: Missing Arguments"
    exit 1
fi

Solver_ID=$1

# Supported solvers are 1, 2, 8, 12, 14, 43, and 83. Please see ij_doc.txt
if [[ "$Solver_ID" != "1" && "$Solver_ID" != "2" && "$Solver_ID" != "8" && "$Solver_ID" != "12" && "$Solver_ID" != "14" && "$Solver_ID" != "43" && "$Solver_ID" != "83"  && "$Solver_ID" != "-1" ]]; then
    echo "Error: Unsupported Solver ID $Solver_ID. Please see ij_doc.txt for supported solvers"
    exit 1
fi


Grid_size=$2
Max_iters=$3
Num_runs=$4
directory="LOBPCG_TESTS/LOBPCG_${Solver_ID}_${Grid_size}_${Max_iters}_${Num_runs}"

# Check if the directory already exists
if [ -d "$directory" ]; then
    echo "Error: Directory $directory already exists."
    exit 1
fi

mkdir -p "$directory"

# Run with no solver
if [ "$Solver_ID" == "-1" ]; then 
    for i in $(seq 1 "$Num_runs")
    do 
        mpirun -np 2 ./ij -lobpcg -itr "$Max_iters" -solver none -n "$Grid_size" "$Grid_size" "$Grid_size" -shift 0.5 -k 50 -vout 2
        python3 experiment_cleanup.py "sample_run_$i.csv"
        rm res_hist.txt val_hist.txt values.txt residuals.txt vectors.0.0 vectors.0.INFO.0
        mv "sample_run_$i.csv" "$directory/"
    done
# Run with a solver
else 
    for i in $(seq 1 "$Num_runs")
    do 
        mpirun -np 2 ./ij -lobpcg -itr "$Max_iters" -solver "$Solver_ID" -n "$Grid_size" "$Grid_size" "$Grid_size" -shift 0.5 -k 50 -vout 2
        python3 experiment_cleanup.py "sample_run_$i.csv"
        rm res_hist.txt val_hist.txt values.txt residuals.txt vectors.0.0 vectors.0.INFO.0
        mv "sample_run_$i.csv" "$directory/"
    done
fi

