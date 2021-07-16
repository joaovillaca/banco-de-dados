CREATE TABLE Turista (
	PaisOrigem VARCHAR(50),
	NumPassaporte VARCHAR(20),
	Nome VARCHAR(100) NOT NULL,
	DataNascimento DATE NOT NULL,
	Telefone VARCHAR(25) NOT NULL,
	Email VARCHAR(254) NOT NULL,
	Senha VARCHAR(25) NOT NULL,
	PRIMARY KEY(PaisOrigem, NumPassaporte)
);

CREATE TABLE Pais (
	Nome VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Festival (
	IdFiscal VARCHAR(30) PRIMARY KEY,
	Nome VARCHAR(25) NOT NULL,
	Pais VARCHAR(50) NOT NULL REFERENCES Pais,
	Descricao VARCHAR(300),
	DataInicio DATE NOT NULL,
	DataFim DATE NOT NULL,
	EstiloMusica VARCHAR(20),
	Cidade VARCHAR(50) NOT NULL,
	ZipCode VARCHAR(30),
	Bairro VARCHAR(50),
	Logradouro VARCHAR(100),
	Numero INTEGER
);

CREATE TABLE Festa (
	Festival VARCHAR(30) REFERENCES Festival,
	Nome VARCHAR(25),
	Capacidade INTEGER NOT NULL,
	DataFesta DATE NOT NULL,
	HoraInicio TIME NOT NULL,
	HoraFim TIME NOT NULL,
	PRIMARY KEY (Festival, Nome)
);

CREATE TABLE Atracoes (
	Festival VARCHAR(30),
	Festa VARCHAR(25),
	Atracao VARCHAR(25),
	Descricao VARCHAR(300),
	FOREIGN KEY (Festival, Festa) REFERENCES Festa (Festival, Nome),
	PRIMARY KEY (Festival, Festa, Atracao)
);

CREATE TABLE Ingresso (
	Festival VARCHAR(30),
	Festa VARCHAR(25),
	NumIngresso VARCHAR(30),
	PaisTurista VARCHAR(50),
	TuristaPassaporte VARCHAR(20),
	Preco NUMERIC NOT NULL CHECK (Preco >= 0),
	DataValidade DATE NOT NULL,
	NumCompra VARCHAR(25),
	DataCompra DATE,
	HoraCompra TIME,
	FOREIGN KEY (Festival, Festa) REFERENCES Festa (Festival, Nome),
	FOREIGN KEY (PaisTurista, TuristaPassaporte) REFERENCES Turista (PaisOrigem, NumPassaporte),
	PRIMARY KEY (Festival, Festa, NumIngresso)
);

CREATE TABLE ServicoHospedagem (
	IdFiscal VARCHAR(30) PRIMARY KEY,
	Pais VARCHAR(50) NOT NULL REFERENCES Pais,
	TipoAcomodacao VARCHAR(25),
	Nome VARCHAR(25) NOT NULL,
	Descricao VARCHAR(300),
	Cidade VARCHAR(50) NOT NULL,
	ZipCode VARCHAR(30),
	Bairro VARCHAR(50),
	Logradouro VARCHAR(100),
	Numero INTEGER
);

CREATE TABLE Hotel (
	IdFiscal VARCHAR(30) REFERENCES ServicoHospedagem PRIMARY KEY,
	Classificacao INTEGER NOT NULL CHECK (Classificacao >= 0 AND Classificacao <= 5),
	PrecoDiaria NUMERIC NOT NULL CHECK (PrecoDiaria > 0)
);

CREATE TABLE Pousada (
	IdFiscal VARCHAR(30) REFERENCES ServicoHospedagem PRIMARY KEY,
	PrecoDiaria NUMERIC NOT NULL CHECK (PrecoDiaria > 0)
);

CREATE TABLE Hostel (
	IdFiscal VARCHAR(30) REFERENCES ServicoHospedagem PRIMARY KEY
);

CREATE TABLE TipoDormitorio (
	Hostel VARCHAR(30) REFERENCES Hostel,
	PrecoDiaria NUMERIC CHECK (PrecoDiaria > 0),
	Capacidade INTEGER CHECK (Capacidade > 0),
	PRIMARY KEY (Hostel, PrecoDiaria, Capacidade)
);

CREATE TABLE Reserva (
	ServicoHospedagem VARCHAR(30) REFERENCES ServicoHospedagem,
	PaisTurista VARCHAR(50),
	TuristaPassaporte VARCHAR(20),
	NumReserva VARCHAR(25),
	DataCheckin DATE NOT NULL,
	DataCheckout DATE NOT NULL,
	NumPessoas INTEGER NOT NULL CHECK (NumPessoas > 0),
	FOREIGN KEY (PaisTurista, TuristaPassaporte) REFERENCES Turista (PaisOrigem, NumPassaporte),
	PRIMARY KEY (ServicoHospedagem, PaisTurista, TuristaPassaporte, NumReserva)
);

CREATE TABLE CompanhiaAerea (
	IdFiscal VARCHAR(30) PRIMARY KEY,
	Nome VARCHAR(25) NOT NULL,
	Pais VARCHAR(50),
	Cidade VARCHAR(50),
	ZipCode VARCHAR(30),
	Bairro VARCHAR(50),
	Logradouro VARCHAR(100),
	Numero INTEGER
);

CREATE TABLE Aviao (
	NumeroCauda VARCHAR(30) PRIMARY KEY,
	CompanhiaProprietaria VARCHAR(30) REFERENCES CompanhiaAerea,
	Nome VARCHAR(25) NOT NULL,
	Fabricante VARCHAR(25) NOT NULL,
	Capacidade INTEGER NOT NULL CHECK (Capacidade > 0)
);

CREATE TABLE Voo (
	Id SERIAL PRIMARY KEY,
	NumeroVoo VARCHAR(25) NOT NULL,
	DataSaida DATE NOT NULL,
	HorarioSaida TIME NOT NULL,
	PaisDestino VARCHAR(50) NOT NULL REFERENCES Pais,
	PaisOrigem VARCHAR(50) NOT NULL,
	Aviao VARCHAR(30) NOT NULL REFERENCES Aviao,
	UNIQUE (NumeroVoo, DataSaida, HorarioSaida)
);

CREATE TABLE Passagem (
	NumTicketEletronico VARCHAR(25) PRIMARY KEY,
	Voo SERIAL NOT NULL REFERENCES Voo,
	CidadeOrigem VARCHAR(30) NOT NULL,
	CidadeDestino VARCHAR(30) NOT NULL,
	Classe VARCHAR(30) NOT NULL,
	DataEmbarque DATE NOT NULL,
	HorarioEmbarque TIME NOT NULL,
	Portao VARCHAR(5) NOT NULL,
	Assento VARCHAR(5),
	Preco NUMERIC NOT NULL,
	NomePassageiro VARCHAR(100),
	PassaportePassageiro VARCHAR(20),
	NumCompra VARCHAR(25),
	DataCompra DATE,
	HoraCompra TIME,
	PaisTuristaComprador VARCHAR(50),
	PassaporteTuristaComprador VARCHAR(20),
	FOREIGN KEY (PaisTuristaComprador, PassaporteTuristaComprador) REFERENCES Turista (PaisOrigem, NumPassaporte)
);
