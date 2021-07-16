/* Consulta 1: Nome e País de origem de todos os Turistas que participam do Festival Tomorrowland */
SELECT DISTINCT T.Nome, T.NumPassaporte, I.PaisTurista as paisOrigem
FROM Ingresso I, Turista T
WHERE I.PaisTurista = T.PaisOrigem 
  AND I.TuristaPassaporte = T.NumPassaporte 
  AND I.Festival = ( SELECT IdFiscal 
                     FROM Festival 
                     WHERE Nome = 'Tomorrowland');
	
/* Consulta 2: Voos com destino ao Brasil realizados pela Hong Kong Airlines */
SELECT DISTINCT V.NumeroVoo, V.DataSaida, V.HorarioSaida, 
                P.CidadeOrigem, P.CidadeDestino, 
                A.Nome as Aviao, A.Capacidade
FROM Voo V, Passagem P, Aviao A
WHERE V.PaisDestino = 'Brazil' 
  AND V.Id = P.Voo 
  AND V.Aviao = A.NumeroCauda 
  AND A.CompanhiaProprietaria = ( SELECT IdFiscal 
                                  FROM companhiaAerea 
                                  WHERE Nome = 'Hong Kong Airlines');	
	
/* Consulta 3 (Divisão): Turistas que vão para todas as festas da Tomorrowland */
/* Turistas */
SELECT T.Nome, T.NumPassaporte, T.PaisOrigem
FROM Turista T
WHERE NOT EXISTS (( SELECT Nome 
					FROM Festa 
					WHERE Festival = 3
					EXCEPT
				  ( SELECT Festa
					FROM Ingresso
					WHERE PaisTurista = T.PaisOrigem 
                      AND TuristaPassaporte = T.NumPassaporte));

/* Consulta 4: Hostels que estão na mesma cidade que o Rock In Rio e possuem dormitórios com capacidade entre 2 a 4 pessoas */
SELECT S.Nome , T.PrecoDiaria, T.Capacidade as CapacidadeDorm
FROM ServicoHospedagem S, Festival F, TipoDormitorio T
WHERE S.TipoAcomodacao = 'Hostel' 
  AND S.Cidade = F.Cidade 
  AND F.Cidade = ( SELECT Cidade 
                   FROM Festival 
                   WHERE Nome = 'Rock in Rio') 
                     AND T.Capacidade >= 2 
                     AND T.Capacidade <= 4;

/* Consulta 5: Selecionar Nome e Idade do Turista mais velho que participa do Rock in Rio */
SELECT Nome, age(DataNascimento) as Idade
FROM Turista
WHERE DataNascimento IN (SELECT min(T.DataNascimento)
						 FROM Ingresso I, Turista T
						 WHERE I.PaisTurista = T.PaisOrigem 
                           AND I.TuristaPassaporte = T.NumPassaporte 
                           AND I.Festival = ( SELECT IdFiscal 
                                              FROM Festival 
                                              WHERE Nome = 'Rock in Rio'));

/* Consulta 6: Número de Ingressos comprados e gasto total, de forma decrescente, de cada Turista que participa do Rock in Rio*/
SELECT T.Nome as Nome_Turista, T.PaisOrigem, T.NumPassaporte, 
        COUNT(I.NumIngresso) as Ingressos_Comprados, 
        SUM(I.Preco) as Gasto_Total
FROM Ingresso I, Turista T
WHERE I.PaisTurista = T.PaisOrigem 
  AND I.TuristaPassaporte = T.NumPassaporte
  AND I.Festival = ( SELECT IdFiscal 
				     FROM Festival 
				     WHERE Nome = 'Rock in Rio')
GROUP BY Nome_Turista, T.PaisOrigem, T.NumPassaporte
ORDER BY Gasto_Total DESC;

/* Consulta 7: Nome de Turistas que compraram ingresso para uma festa no qual o Alok apresenta*/
SELECT DISTINCT T.Nome as Turista, I.Festa, F.Nome as Festival 
FROM Ingresso I, Turista T, Atracoes A, Festival F
WHERE I.PaisTurista = T.PaisOrigem 
  AND I.TuristaPassaporte = T.NumPassaporte 
  AND A.Atracao = 'Alok' 
  AND I.Festa = A.Festa 
  AND I.Festival = F.IdFiscal
ORDER BY Festival;


	