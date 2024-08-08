# orientdb - nosql / document/ multi-model /graph db

# sra format
# ...

# google cloud
https://www.ncbi.nlm.nih.gov/sra/docs/sra- cloud/

# sra db
https://gbnci.cancer.gov/backup/SRAmetadb.sqlite.gz #20221207

# sra sqlite query over input file ids
# put input file into id,data format ; csv is convenient
sqlite3 SRAmetadb.sqlite
sqlite> create temporary table ids (id integer primary key, rid varchar);
sqlite> .import 't' ids
sqlite> .mode csv
sqlite> .import 't' ids
# join on id
sqlite> select * from ids limit 5 ;
id,rid
1,ERR4691828
2,ERR4691826
3,ERR4691827
sqlite> select sum(bases) from sra s inner join ids i on s.run_accession=i.rid ;

# sra (2021-11-25)
https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=announcement
# most bases are not open
sqlite3 SRAmetadb.sqlite
sqlite> select sum(bases) from sra;
5.6435122136965e+15
sqlite> select count(*) from sra;
4098077

# sra batch
esearch -db sra -query | efetch --format runinfo | cut -d ',' -f 1 | grep SRR | xargs fastq-dump --split-files --bzip2

# sra metagenomes vs amplicon https://edwards.sdsu.edu/research/how-many-bp-of-metagenomes-are-there-in-the-sra/
use https://github.com/linsalrob/partie to separate amplicons from MG

# sra marine metagenomes
W# see https://linsalrob.github.io/ComputationalGenomicsManual/Databases/SRA.html
/usr/local/Cellar/edirect/15.3/bin/esearch -db sra -query '("metagenome"[Organism] OR metagenome[All Fields]) AND "marine metagenome"[orgn] AND ("biomol dna"[Properties] AND "strategy wgs"[Properties] AND "platform illumina"[Properties])' | /usr/local/Cellar/edirect/15.3/bin/efetch -format runinfo > /tmp/marine.csv
# Tara oceans
https://www.ncbi.nlm.nih.gov/sra/?term=Tara+Oceans
28TBp

# s3 public data
https://registry.opendata.aws
aws s3 ls  s3://sra-pub-src-2

# aws sra: aws s3 ls  s3://sra-pub-src-2

# ascp
ascp -QT -l 200m -P33001 -i "/Applications/Aspera Connect.app/Contents/Resources/asperaweb_id_dsa.openssh" era-fasp@fasp.sra.ebi.ac.uk:/vol1/fastq/ERR172/002/ERR1729192/ERR1729192.fastq.gz .
ascp -QT -l 200m -i "/Applications/Aspera Connect.app/Contents/Resources/asperaweb_id_dsa.openssh" era-fasp@fasp.sra.ebi.ac.uk:/vol1/fastq/ERR172/002/ERR1729192/ERR1729192.fastq.gz .


# ncbi downloads
https://www.ncbi.nlm.nih.gov/public/
ftp://ftp.ncbi.nlm.nih.gov/sra/sra-instant/reads/ByRun/sra/ERR/ERR261/ERR2618717/

# srametadb
# dead http://gbnci.abcc.ncifcrf.gov/backup/SRAmetadb.sqlite.gz
# dead http://watson.nci.nih.gov/~zhujack/SRAmetadb.sqlite.gz
# dead http://dl.dropbox.com/u/51653511/SRAmetadb.sqlite.gz
https://starbuck1.s3.amazonaws.com/sradb/SRAmetadb.sqlite.gz

# sradb (from getSRAdbFile.R)
# https://www.ncbi.nlm.nih.gov/books/NBK47528/
url_sra_4='https://starbuck1.s3.amazonaws.com/sradb/SRAmetadb.sqlite.gz'
rs <- dbGetQuery(sra_con, c("SELECT study_type AS StudyType count(*) AS Number FROM `study` GROUP BY study_type order by Number DESC")
dbGetQuery(sra_con, c("SELECT instrument_model AS 'Model', count(*) AS Expts FROM `experiment` GROUP BY instrument_model order by Experiments DESC")
dbGetQuery(sra_con, c("SELECT library_strategy AS 'LibStrat', count(*) AS Runs FROM `experiment` GROUP BY library_strategy order by Runs DESC")
sraConvert( c('SRP001007','SRP000931'), sra_con = sra_con )

# find sra files
sra explorer: https://ewels.github.io/sra-explorer/#

# srametadb
# dead http://gbnci.abcc.ncifcrf.gov/backup/SRAmetadb.sqlite.gz
# dead http://watson.nci.nih.gov/~zhujack/SRAmetadb.sqlite.gz
# dead http://dl.dropbox.com/u/51653511/SRAmetadb.sqlite.gz
https://starbuck1.s3.amazonaws.com/sradb/SRAmetadb.sqlite.gz

# sradb (from getSRAdbFile.R)
# https://www.ncbi.nlm.nih.gov/books/NBK47528/
url_sra_4='https://starbuck1.s3.amazonaws.com/sradb/SRAmetadb.sqlite.gz'
rs <- dbGetQuery(sra_con, c("SELECT study_type AS StudyType count(*) AS Number FROM `study` GROUP BY study_type order by Number DESC")
dbGetQuery(sra_con, c("SELECT instrument_model AS 'Model', count(*) AS Expts FROM `experiment` GROUP BY instrument_model order by Experiments DESC")
dbGetQuery(sra_con, c("SELECT library_strategy AS 'LibStrat', count(*) AS Runs FROM `experiment` GROUP BY library_strategy order by Runs DESC")
sraConvert( c('SRP001007','SRP000931'), sra_con = sra_con )

# sra (2021-11-25)
https://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?view=announcement
# most bases are not open
sqlite3 SRAmetadb.sqlite
sqlite> select sum(bases) from sra;
5.6435122136965e+15
sqlite> select count(*) from sra;
4098077

# SRAdb  # updated db :  https://gbnci-abcc.ncifcrf.gov/backup/SRAmetadb.sqlite.gz'
install.packages("BiocManager",repos="https://cloud.r-project.org")
BiocManager::install("SRAdb")
biocLite("SRAdb")
library("SRAdb")
