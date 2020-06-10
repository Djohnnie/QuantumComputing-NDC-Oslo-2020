namespace Teleportation {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    

    @EntryPoint()
    operation HelloQ() : Unit {
        
        Teleport(true);

        Teleport(false);
        
        Teleport(false);

        Teleport(true);
    }

    operation Teleport(message: Bool) : Unit
    {
        using( qRegistry = Qubit[3] )
        {
            let qMessage = qRegistry[0];
            let qAlice = qRegistry[1];
            let qBob = qRegistry[2];

            // Set qubit to teleport to required state
			// based on random message.
			if( message )
            {
                X(qMessage);
            }

            // Entangle Alice and Bob qubits
			H(qAlice);
			CNOT(qAlice, qBob);

			// Entangle Alice and Message
			CNOT(qMessage, qAlice);
			H(qMessage);

			let bAlice = M(qAlice);
			if( bAlice == One )
			{
				X(qBob);
			}

			let bMessage = M(qMessage);
			if( bMessage == One )
			{
				Z(qBob);
			}

			let bBob = M(qBob);

            Message( "Teleported " + BoolAsString(message) + " to " + BoolAsString(bBob == One));

			// Reset Qubits.
			Reset(qMessage);
			Reset(qAlice);
			Reset(qBob);
        }
    }
}

