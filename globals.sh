# to be sourced

D5P=/work/software/drive5
USEARCH=$D5P/usearch10.0.240_i86linux32
FQ2FASTQ=$D5P/py/faqual2fastq.py
FQRELABEL=$D5P/py/fastq_strip_barcode_relabel2.py
NUMBER=$D5P/py/fasta_number.py
UC2OTUTAB=$D5P/py/uc2otutab.py

RDPT=/work/software/RDPTools
CLFRJAR=$RDPT/classifier.jar

# e.g.
# the mysql_host command should echo the hostname of the mysql server
HOST=`mysql_host`
DB=pesticide_community

# e.g.
RUNS="052517MA1 052517MA2"
PRIMER=CCTACGGGNGGCWGCAG

# adjust for your data
TRUNCLEN=410
MAXEE=1
CLUSTER_IDENT=0.97

SAMPLE_INFO=sample_info.xls
SAMPLE_INFO_SUBSET=sample_info.subset.xls

# e.g.
OUTPUT_NAME=pesticide_community
PERSISTENT_BEST_PCNT=.50
