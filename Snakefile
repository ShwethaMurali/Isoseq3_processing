#Snakemake for running isoseq3 on one smrtcell
import os

configfile : "config.json"
#ccsbam = config["ccs_bam"]

GROUP = config["group"]
NAMES = []
NAMES = config[GROUP].keys()
BAMS = config[GROUP].values()
print ("NAMES:",NAMES)
print ("BAMS", BAMS)
print ("GROUP", config[GROUP])
grp = config[GROUP]
#print (grp["rhesus0"])
#print (grp["rhesus1"])
#rhesus0_full_path = grp["rhesus0"]
#rhesus1_full_path = grp["rhesus1"]

rule all: 
	input: expand("{names}_polished.bam", names=NAMES), expand("{names}_flnc.fasta", names=NAMES)

rule polish: 
	input: unpolish = "{names}_unpolished.bam", subreads="data/{names}.subreads.bam"
	output: "{names}_polished.bam"
	params: sge_opts = config["cluster_settings"]["heaviest"]
	shell: """ source activate anaCogent5.2 ; isoseq3 polish -j 16 {input.unpolish} {input.subreads} {output} """

rule flnc_fasta: 
	input: "{names}_unpolished.flnc.bam"
	output: "{names}_flnc.fasta"
	shell: """ module load bamtools/latest; bamtools convert -format fasta -in {input} > {output} """

rule cluster: 
	input: "{names}_combined.bam"
	output: "{names}_unpolished.bam", "{names}_unpolished.flnc.bam"
	params: sge_opts = config["cluster_settings"]["heaviest"]
	shell: """  source activate anaCogent5.2 ; isoseq3 cluster {input}  {output} -j 16 """


rule create_dataset: 
	input: "{names}_lima_done.list"
	output: "{names}_combined.bam"
	shell: 	"""module load bamtools/latest;  bamtools merge -list {input}  -out {output} """

rule lima: 
	input: "ccs/{names}.ccs.bam", primers=config["primers_fasta"]
	output : "{names}_lima_done.list"
	params: sge_opts = config["cluster_settings"]["heaviest"]
	shell: """ source activate anaCogent5.2 ;  
	lima --isoseq --dump-clips -j 16 {input[0]} {input.primers} {wildcards.names}_demux.bam ; ls {wildcards.names}_demux*.bam > {output} """

rule subreads_to_ccs:
	input: SUBREADS="data/{names}.subreads.bam", CCS="/net/eichler/vol24/projects/sequencing/pacbio/smrt-link/smrtcmds/bin/ccs"
	output: "ccs/{names}.ccs.bam","ccs/{names}.ccs_report.txt"
	shell: "{input.CCS} --numThreads=16 --minLength=100 --maxLength=10000 --minPasses=1 --reportFile={output[1]} {input.SUBREADS} {output[0]}"
