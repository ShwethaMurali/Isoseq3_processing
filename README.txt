All instructions for Isoseq3 taken from here: https://github.com/PacificBiosciences/IsoSeq_SA3nUP/wiki/Tutorial:-Installing-and-Running-Iso-Seq-3-using-Conda

!! Not tested on the cluster, only tested on lynx !!


TROUBLESHOOTING:
* Make sure the input bam is indexed 


* Incase the virtual environment does not load, try installing and making the 
virtual env yourself as follows (from the Isoseq3 tutorial: )

	(1) Download the latest version of Anaconda. (2) Install Anaconda according to the tutorial.

	bash ~/Downloads/Anaconda2-5.2.0-Linux-x86_64.sh
	export PATH=$HOME/anaconda5.2/bin:$PATH
	Add export PATH=$HOME/anaconda5.2/bin:$PATH line to .bashrc or .bash_profile in your home 
        directory or you will need to type it everytime you log in.

	(3) Confirm that conda is installed and update conda:

	conda -V
	conda update conda
	(4) Create a virtual environment (tutorial). I will call it anaCogent5.2. Type y to agree 
        to the interactive questions.

	conda create -n anaCogent5.2 python=2.7 anaconda
	source activate anaCogent5.2
	Once you have activated the virtualenv, you should see your prompt changing to something 
        like this:

	(anaCogent5.2)-bash-4.1$
	(5) Install additional required libraries:

	conda install -n anaCogent5.2 biopython
	conda install -n anaCogent5.2 -c http://conda.anaconda.org/cgat bx-python
	(6) Install Iso-Seq 3 using bioconda. This will also install LIMA, PacBio's demultiplexing 
        tool, as part of the dependency.

	conda install -n anaCogent5.2 -c bioconda isoseq3
	The packages below are optional:

	conda install -n anaCogent5.2 -c bioconda pbcoretools # for manipulating PacBio datasets
	conda install -n anaCogent5.2 -c bioconda bamtools    # for converting BAM to fasta
	conda install -n anaCogent5.2 -c bioconda pysam       # for making CSV reports
