DROP DATABASE IF EXISTS sistema_requerimento;

CREATE DATABASE sistema_requerimento;

\c sistema_requerimento;

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

CREATE TABLE tipo_requerimento (
    id serial primary key,
    descricao text not null
);
INSERT INTO tipo_requerimento (descricao) VALUES
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

CREATE TABLE requerimento (
    id serial primary key,
    aluno_matricula character(10) references aluno (matricula),
    data_hora_abertura timestamp default current_timestamp,
    data_hora_encerramento timestamp,
    observacao text,
    status text check(status in ('EM ANÁLISE', 'INDEFERIDO', 'DEFERIDO')) DEFAULT 'EM ANÁLISE',
    tipo_requerimento_id integer references tipo_requerimento (id) -- fk
);
INSERT INTO requerimento (aluno_matricula, tipo_requerimento_id) VALUES
('1231231231', 12); -- IGOR pediu REINGRESSO e automagicamente fica em analise (valor default)

INSERT INTO requerimento (aluno_matricula, tipo_requerimento_id) VALUES
('1231231231', 18);

INSERT INTO requerimento (aluno_matricula, tipo_requerimento_id) VALUES
('1231231231', 1);

INSERT INTO requerimento (aluno_matricula, tipo_requerimento_id) VALUES
('1231231232', 1);

CREATE TABLE anexo (
    id serial primary key,
    descricao text not null,
    arquivo bytea,
    requerimento_id integer references requerimento (id) -- fk
);
INSERT INTO anexo (descricao, arquivo, requerimento_id) VALUES
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

-- (SELECT matricula FROM aluno) EXCEPT (SELECT aluno_matricula FROM requerimento);

-- 7
-- SELECT requerimento.id, anexo.descricao FROM requerimento left join anexo on (requerimento.id = anexo.requerimento_id);


-- SELECT requerimento.id, coalesce(anexo.descricao, 'sem descricao') as descricao FROM requerimento left join anexo on (requerimento.id = anexo.requerimento_id);

SELECT requerimento.id, 
    case
        when anexo.descricao is null then 'sem descricao'
    else anexo.descricao
end as descricao
FROM 
    requerimento left join anexo on (requerimento.id = anexo.requerimento_id);
    
-- 8) SELECT aluno.matricula, requerimento.id FROM aluno FULL JOIN requerimento on (aluno.matricula = requerimento.aluno_matricula)

-- 9)
-- SELECT * FROM tipo_requerimento WHERE id NOT in(SELECT tipo_requerimento_id FROM requerimento);
-- 9)SELECT tipo_requerimento.descricao FROM tipo_requerimento LEFT JOIN requerimento on (tipo_requerimento.id = requerimento.tipo_requerimento_id) where requerimento.tipo_requerimento_id IS NULL;

-- 10)

-- 11) SELECT * from usuario inner join aluno on (usuario.id = aluno.usuario_id) inner join requerimento on (aluno.matricula = requerimento.aluno_matricula) where requerimento.status = 'DEFERIDO';

-- 11) CREATE VIEW qtde_requerimento_por_tipo AS SELECT tipo_requerimento.id, tipo_requerimento.descricao, count(requerimento.tipo_requerimento_id) FROM requerimento inner join tipo_requerimento on (requerimento.tipo_requerimento_id = tipo_requerimento.id) GROUP BY tipo_requerimento.id, tipo_requerimento.descricao, requerimento.tipo_requerimento_id;

-- off-topic: group by / having
-- SELECT tipo_requerimento.id, tipo_requerimento.descricao, count(requerimento.tipo_requerimento_id) FROM requerimento inner join tipo_requerimento on (requerimento.tipo_requerimento_id = tipo_requerimento.id) GROUP BY tipo_requerimento.id, tipo_requerimento.descricao, requerimento.tipo_requerimento_id having count(tipo_requerimento_id) >= 2;

-- 14) SELECT aluno.matricula, count(requerimento.aluno_matricula) FROM aluno inner join requerimento on (aluno.matricula = requerimento.aluno_matricula) GROUP BY aluno.matricula, requerimento.aluno_matricula having count(requerimento.aluno_matricula) > 1;
