import gzip
from glob import glob
import os,time,random


#time.sleep(30000)
fixed_files = []
while True:
    set_fixed_files = set(fixed_files)
    zipped_files = list(glob('bluesky_data/*.gz'))
    cleaned_zipped_files = [file for file in zipped_files if file not in set_fixed_files]
    random.shuffle(cleaned_zipped_files)
    for file in cleaned_zipped_files:
        try:
            txt_file = gzip.open(file)
            unique_lines = set()
            compressed_line = []
            for line in txt_file:
                line = line.decode('UTF-8')
                if line not in unique_lines:
                    unique_lines.add(line)
                    compressed_line.append(line)
            outfile = file.replace('.gz','')
            w = open(outfile,'w')
            for line in compressed_line:
                w.write(line)
            w.close()
            os.system('rm '+file)
            os.system('gzip '+outfile)
            fixed_files.append(outfile)
        except:
            print(file)
            continue
    time.sleep(3600)
