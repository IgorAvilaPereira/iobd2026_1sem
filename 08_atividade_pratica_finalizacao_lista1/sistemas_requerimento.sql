DROP DATABASE IF EXISTS sistema_requerimento;

CREATE DATABASE sistema_requerimento;

\c sistema_requerimento;

CREATE SCHEMA esquema_requerimento;

-- adicionando o esquema no conjunto de esquemas
SET search_path TO public, esquema_requerimento;

CREATE TABLE curso (
    id serial primary key,
    nome character varying(200) not null,
    site character varying(200),
    turno character varying(200) check(turno in('NOTURNO', 'DIURNO', 'VESPERTINO')),
    duracao integer check(duracao > 0) -- em horas
);

INSERT INTO curso (nome, site, turno, duracao) VALUES
('TECNOLOGIA EM ANÁLISE E DESENVOLVIMENTO DE SISTEMAS', 'http://tads.riogrande.ifrs.edu.br', 'NOTURNO', 2147),
('ENGENHARIA MECÂNICA', NULL, 'NOTURNO', 2000),
('ARQUITETURA', NULL, 'VESPERTINO', 2500);

CREATE TABLE usuario (
    id serial primary key,
    nome character varying(200) not null,
    email character varying(200) unique,
    cpf character(11) unique,
    data_nascimento date,
    cep character(8),
    rua text,
    complemento text,
    nro character varying(10)
);
INSERT INTO usuario (nome, email, cpf) VALUES
('IGOR AVILA PEREIRA', 'igor.pereira@riogrande.ifrs.edu.br', '11111111111'),
('RAFAEL BETITO', 'rafael.betito@riogrande.ifrs.edu.br', '22222222222'),
('MÁRCIO JOSUÉ RAMOS TORRES', 'marcio.torres@riogrande.ifrs.edu.br', '3333333333');

CREATE TABLE aluno (
    matricula character(10) primary key,
    usuario_id integer references usuario (id), -- fk
    curso_id integer references curso (id) -- fk
);
INSERT INTO aluno (matricula, usuario_id, curso_id) VALUES
('1231231231', 1, 1),
('1231231232', 2, 1),
('1231231131', 3, 1);

ALTER TABLE aluno ADD COLUMN status text check(status in('CURSANDO', 'ABANDONO', 'TRANCADO', 'FORMADO')) DEFAULT 'CURSANDO';

UPDATE aluno SET status = 'FORMADO' where matricula = '1231231231';



INSERT INTO aluno (matricula, usuario_id, curso_id) VALUES
('1231231235', 1, 2);

INSERT INTO aluno (matricula, usuario_id, curso_id) VALUES
('1231231230', 1, 2);

CREATE TABLE esquema_requerimento.tipo_requerimento (
    id serial primary key,
    descricao text not null
);
INSERT INTO esquema_requerimento.tipo_requerimento (descricao) VALUES
('Abreviação de Curso Superior ou Antecipação de Colação'),
('Ajuste de Matrícula'),
('Aproveitamento de Estudos'),
('Atestado de Frequência'),
('Certificação de Conhecimentos'),
('Certificação ENEM ou ENCCEJA'),
('Cancelamento de Matrícula'),
('Histórico'),
('Justificativa ou Abono de Faltas e Solicitação de Segunda Chamada'),
('Registro de Nome Social'),
('Quebra de Pré-Requisito'),
('Reingresso'),
('Rematrícula'),
('Revisão de Prova ou Exame'),
('Trancamento de Disciplina'),
('Trancamento de Matrícula'),
('Troca de Turma'),
('Validação de Atividades Complementares');

CREATE TABLE esquema_requerimento.requerimento (
    id serial primary key,
    aluno_matricula character(10) references aluno (matricula),
    data_hora_abertura timestamp default current_timestamp,
    data_hora_encerramento timestamp,
    observacao text,
    status text check(status in ('EM ANÁLISE', 'INDEFERIDO', 'DEFERIDO')) DEFAULT 'EM ANÁLISE',
    tipo_requerimento_id integer references tipo_requerimento (id) -- fk
);
INSERT INTO esquema_requerimento.requerimento (aluno_matricula, tipo_requerimento_id) VALUES
('1231231231', 12); -- IGOR pediu REINGRESSO e automagicamente fica em analise (valor default)

INSERT INTO esquema_requerimento.requerimento (aluno_matricula, tipo_requerimento_id) VALUES
('1231231231', 18);

INSERT INTO esquema_requerimento.requerimento (aluno_matricula, tipo_requerimento_id) VALUES
('1231231231', 1);

INSERT INTO esquema_requerimento.requerimento (aluno_matricula, tipo_requerimento_id) VALUES
('1231231232', 1);


INSERT INTO esquema_requerimento.requerimento (aluno_matricula, tipo_requerimento_id) VALUES
('1231231131', 8);

INSERT INTO esquema_requerimento.requerimento (aluno_matricula, tipo_requerimento_id) VALUES
('1231231131', 8);

INSERT INTO esquema_requerimento.requerimento (aluno_matricula, tipo_requerimento_id, data_hora_abertura) VALUES
('1231231231', 8,  current_timestamp - interval '1 year');

INSERT INTO esquema_requerimento.requerimento (aluno_matricula, tipo_requerimento_id, data_hora_abertura) VALUES
('1231231232', 8,  current_timestamp - interval '1 year');


INSERT INTO esquema_requerimento.requerimento (aluno_matricula, tipo_requerimento_id, data_hora_abertura) VALUES
('1231231131', 8,  current_timestamp - interval '2 year');



INSERT INTO esquema_requerimento.requerimento (aluno_matricula, tipo_requerimento_id, data_hora_abertura) VALUES
('1231231131', 8, current_timestamp - interval '31 days');



CREATE TABLE esquema_requerimento.anexo (
    id serial primary key,
    descricao text not null,
    arquivo bytea,
    requerimento_id integer references requerimento (id) -- fk
);
INSERT INTO esquema_requerimento.anexo (descricao, arquivo, requerimento_id) VALUES
('HISTÓRICO', NULL, 1);

-- 1
/*
SELECT matricula, usuario.nome, curso.nome FROM aluno INNER JOIN usuario ON (aluno.usuario_id = usuario.id) INNER JOIN curso ON (aluno.curso_id = curso.id);
*/

-- 3
/*
SELECT curso.nome, aluno.matricula, usuario.nome, aluno.status FROM usuario inner join aluno on (usuario.id = aluno.usuario_id) inner join curso on (curso.id = aluno.curso_id) WHERE curso.id = 1 ORDER BY usuario.nome ASC; 
*/

-- 4
/*
 SELECT aluno.matricula, tipo_requerimento.descricao, observacao FROM requerimento INNER JOIN tipo_requerimento ON (requerimento.tipo_requerimento_id = tipo_requerimento.id) inner join aluno on (requerimento.aluno_matricula = aluno.matricula);
*/

-- 5
/*
SELECT aluno.matricula, requerimento.id FROM aluno LEFT JOIN requerimento on (aluno.matricula = requerimento.aluno_matricula);
*/

-- 6
/*
SELECT aluno.matricula, requerimento.id FROM aluno LEFT JOIN requerimento on (aluno.matricula = requerimento.aluno_matricula) where requerimento.id is null;
*/
-- select aluno.matricula from aluno where aluno.matricula not in (select requerimento.aluno_matricula from requerimento);

-- materia_nova: operacoes com conjunto (except == subtrair)
-- (SELECT matricula FROM aluno) EXCEPT (SELECT aluno_matricula FROM requerimento);

-- 7
-- SELECT requerimento.id, anexo.descricao FROM requerimento left join anexo on (requerimento.id = anexo.requerimento_id);


-- SELECT requerimento.id, coalesce(anexo.descricao, 'sem descricao') as descricao FROM requerimento left join anexo on (requerimento.id = anexo.requerimento_id);

-- materia_nova: case_when
/*
SELECT requerimento.id, 
    case
        when anexo.descricao is null then 'sem descricao'
    else anexo.descricao
end as descricao
FROM 
    requerimento left join anexo on (requerimento.id = anexo.requerimento_id);
  */  
-- 8) SELECT aluno.matricula, requerimento.id FROM aluno FULL JOIN requerimento on (aluno.matricula = requerimento.aluno_matricula)

-- 9) materia_nova: subselect
-- SELECT * FROM tipo_requerimento WHERE id NOT in(SELECT tipo_requerimento_id FROM requerimento);
-- 9)SELECT tipo_requerimento.descricao FROM tipo_requerimento LEFT JOIN requerimento on (tipo_requerimento.id = requerimento.tipo_requerimento_id) where requerimento.tipo_requerimento_id IS NULL;

-- 10)

-- 11) SELECT * from usuario inner join aluno on (usuario.id = aluno.usuario_id) inner join requerimento on (aluno.matricula = requerimento.aluno_matricula) where requerimento.status = 'DEFERIDO';

-- materia_nova: view
-- 11) CREATE VIEW qtde_requerimento_por_tipo AS SELECT tipo_requerimento.id, tipo_requerimento.descricao, count(requerimento.tipo_requerimento_id) FROM requerimento inner join tipo_requerimento on (requerimento.tipo_requerimento_id = tipo_requerimento.id) GROUP BY tipo_requerimento.id, tipo_requerimento.descricao, requerimento.tipo_requerimento_id;

-- materia_nova: group by / having
-- SELECT tipo_requerimento.id, tipo_requerimento.descricao, count(requerimento.tipo_requerimento_id) FROM requerimento inner join tipo_requerimento on (requerimento.tipo_requerimento_id = tipo_requerimento.id) GROUP BY tipo_requerimento.id, tipo_requerimento.descricao, requerimento.tipo_requerimento_id having count(tipo_requerimento_id) >= 2;

-- 14) SELECT aluno.matricula, count(requerimento.aluno_matricula) FROM aluno inner join requerimento on (aluno.matricula = requerimento.aluno_matricula) GROUP BY aluno.matricula, requerimento.aluno_matricula having count(requerimento.aluno_matricula) > 1;


-- 15) SELECT requerimento.id, count(requerimento_id) as qtde FROM requerimento left join anexo on (requerimento.id = anexo.requerimento_id) group by requerimento.id, requerimento_id;

INSERT INTO anexo (descricao, arquivo, requerimento_id) values ('DIPLOMA DO CURSO ANTERIOR', NULL, 1);

-- materia_nova string_agg
--SELECT requerimento.id, STRING_AGG(anexo.descricao, ',') as lista_de_anexos FROM requerimento inner join anexo on (requerimento.id = anexo.requerimento_id) group by requerimento.id;


-- 16) Select usuario.id, usuario.nome, string_agg(curso.nome, ','), string_agg(aluno.matricula, ';') FROM usuario inner join aluno on usuario.id = aluno.usuario_id inner join curso on curso.id = aluno.curso_id group by usuario.id;

-- 18) ja fiz

-- 19) jump

-- 20) 

-- 17/03

-- 36) SELECT status, count(status) as qtde from requerimento group by status;

-- 37) SELECT status, count(status) as qtde from requerimento group by status having count(status) > 1;

-- 38)  select aluno.matricula, count(requerimento.aluno_matricula) from requerimento right join aluno on (aluno.matricula = requerimento.aluno_matricula) group by aluno_matricula, aluno.matricula;

-- 39) select extract(year from data_hora_abertura) as ano, count(*) as qtde from requerimento group by ano;


-- off-topic:  
--select 
--    extract(year from data_hora_abertura) as ano, 
--    case 
--        when extract(month from data_hora_abertura) = 3 then 'Março'
--        -- fazer para todos os meses.
--    end as mes, 
--    count(*) as qtde from requerimento 
--group by ano, mes; 

-- 40) fiz no off-topic

-- 41) select avg(duracao)::float as media_horas_duracao from curso;
-- select cast(avg(duracao) as float) as media_horas_duracao from curso;

-- 42) select * from curso where duracao > (select cast(avg(duracao) as float) as media_horas_duracao from curso);

-- materia nova by rogerio
--WITH tabela_media AS (select cast(avg(duracao) as float) as media from curso) select * from curso where duracao > (select media from tabela_media);

ALTER TABLE curso ADD COLUMN ativo boolean DEFAULT true;
ALTER TABLE usuario ADD COLUMN ativo boolean DEFAULT true;


-- select aluno_matricula from requerimento group by aluno_matricula;

-- select distinct aluno_matricula from requerimento;

-- select aluno_matricula, count(*) from requerimento group by aluno_matricula order by count(*) desc limit 1;

-- SELECT aluno_matricula, count(*) from requerimento group by aluno_matricula having count(*) = (select count(*) from requerimento group by aluno_matricula order by count(*) desc limit 1);

-- select extract(year from data_hora_abertura) as ano, count(requerimento.id) as qtde from requerimento group by extract(year from data_hora_abertura);

-- select extract(year from data_hora_abertura) as ano, extract(month from data_hora_abertura) as mes, count(requerimento.id) as qtde from requerimento group by extract(year from data_hora_abertura), extract(month from data_hora_abertura);

-- 49) select tipo_requerimento.descricao, count(*) as qtde from requerimento inner join tipo_requerimento on (requerimento.tipo_requerimento_id = tipo_requerimento.id) group by tipo_requerimento.descricao having count(*) >= 2;

-- SELECT matricula from aluno order by random() limit 1;

-- 50) select anexo.requerimento_id, count(anexo.id) from anexo group by requerimento_id having count(requerimento_id) > 0;

-- 50+completa) select anexo.requerimento_id, tipo_requerimento.descricao, aluno.matricula, count(anexo.id) from anexo inner join requerimento on (anexo.requerimento_id = requerimento.id) inner join tipo_requerimento on (tipo_requerimento.id = requerimento.tipo_requerimento_id) inner join aluno on (aluno.matricula = requerimento.aluno_matricula) group by requerimento_id, tipo_requerimento.descricao, aluno.matricula having count(requerimento_id) > 0;

-- 51) UPDATE requerimento SET status = 'DEFERIDO' where id = 1; 
-- select extract(year from data_hora_abertura) AS ano, count(*) as qtde from requerimento where status in ('INDEFERIDO', 'DEFERIDO')  group by extract(year from data_hora_abertura);

-- 52) select status, count(*) as qtde from requerimento group by status order by count(*) DESC;

-- 53) SELECT curso.nome, count(aluno.curso_id) as qtde FROM curso inner join aluno on (curso.id = aluno.curso_id) group by curso.nome, aluno.curso_id;

-- 54) SELECT curso.nome, count(aluno.curso_id) FROM curso inner join aluno on (curso.id = aluno.curso_id) group by curso.nome, aluno.curso_id having count(aluno.curso_id) > 2;

-- 55) with tb_matricula as (select aluno_matricula from requerimento group by aluno_matricula, extract(year from data_hora_abertura)) select aluno_matricula from tb_matricula group by aluno_matricula having count(*) > 1;

-- 56) select * from requerimento where cast(data_hora_abertura as date) = current_date;

-- 57) jump

-- 58)  select * from requerimento where data_hora_abertura::date >= current_date - interval '30 days';

-- 59) 
/*
select 
    id,
    aluno_matricula,
    status,
    to_char(data_hora_abertura, 'dd/mm/yyyy HH24:MI'),     
    case 
        when extract(dow from data_hora_abertura) = 0 then 'Domingo'
                when extract(dow from data_hora_abertura) = 1 then 'Segunda'
                                when extract(dow from data_hora_abertura) = 2 then 'Terça'
                                                when extract(dow from data_hora_abertura) = 3 then 'Quarta'
                                                                when extract(dow from data_hora_abertura) = 4 then 'Quinta'
                                                                                when extract(dow from data_hora_abertura) = 5 then 'Sexta'
                                                                                                when extract(dow from data_hora_abertura) = 6 then 'Sábado' end as dia_da_semana from requerimento;
*/

UPDATE usuario SET data_nascimento = '1987-01-20' where id = 1;

-- 60) SELECT id, nome, email, extract(year from age(data_nascimento)) as idade FROM usuario;

