DROP DATABASE IF EXISTS sistema_requerimento;

CREATE DATABASE sistema_requerimento;

\c sistema_requerimento;

CREATE TABLE curso (
    id serial primary key,
    nome character varying(200) not null,
    site character varying(200),
    turno character varying(200) check('NOTURNO', 'DIURNO', 'VESPERTINO'),
    duracao integer check(duracao > 0) -- em horas
);

INSERT INTO curso (nome, site, turno, duracao) VALUES
('TECNOLOGIA EM ANÁLISE E DESENVOLVIMENTO DE SISTEMAS', 'http://tads.riogrande.ifrs.edu.br', 'NOTURNO', 2147);

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
('IGOR AVILA PEREIRA', 'igor.pereira@riogrande.ifrs.edu.br', '11111111111');

CREATE TABLE aluno (
    matricula character(10) primary key,
    usuario_id integer references usuario (id), -- fk
    curso_id integer references curso (id) -- fk
);
INSERT INTO aluno (matricula, usuario_id, curso_id) VALUES
('1231231231', 1, 1);


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
INSERT INTO requerimento (aluno_matricula, tipo_requerimento) VALUES
('1231231231', 12); -- IGOR pediu REINGRESSO e automagicamente fica em analise (valor default)

CREATE TABLE anexo (
    id serial primary key,
    descricao text not null,
    arquivo bytea,
    requerimento_id integer references requerimento (id) -- fk
);













CREATE TABLE anexo

