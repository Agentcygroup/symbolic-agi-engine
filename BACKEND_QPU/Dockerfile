FROM continuumio/miniconda3

WORKDIR /app
COPY quantum.yml quantum.yml

RUN conda update -n base -c defaults conda -y && \
    conda env create -f quantum.yml

COPY qpu_exec.py qpu_exec.py

RUN echo '#!/bin/bash\nsource activate quantum_env\npython qpu_exec.py' > start.sh && chmod +x start.sh

CMD ["./start.sh"]
