from qiskit import QuantumCircuit, execute
from qiskit_aer import Aer

qc = QuantumCircuit(1,1)
qc.h(0)
qc.measure(0,0)

backend = Aer.get_backend('qasm_simulator')
job = execute(qc, backend, shots=1024)
result = job.result()
counts = result.get_counts(qc)
print("🧠 QPU Result:", counts)
