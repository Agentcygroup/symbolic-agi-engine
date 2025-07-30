from qiskit import QuantumCircuit, Aer, execute
from rich import print

print("🧠 GERHARDT TOTALITY QPU RUNTIME")

qc = QuantumCircuit(2, 2)
qc.h(0)
qc.cx(0, 1)
qc.measure([0, 1], [0, 1])

backend = Aer.get_backend("qasm_simulator")
result = execute(qc, backend, shots=512).result()
counts = result.get_counts()

print(f"[bold green]Measurement Result:[/bold green] {counts}")
