CREATE TABLE IF NOT EXISTS authors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS titles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    author_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    word_count INT NOT NULL,
    views INT NOT NULL DEFAULT 0,

    INDEX idx_titles_author_id (author_id),

    CONSTRAINT fk_author_id
        FOREIGN KEY (author_id)
        REFERENCES authors(id)
        ON DELETE CASCADE
);

INSERT INTO authors (name) VALUES
    ('Maria Charlotte'),
    ('Juan Perez'),
    ('Gemma Alcocer');

INSERT INTO titles (title, word_count, views, author_id) VALUES
    ('Small Space Decorating Tips', 1146, 221,
    (SELECT id FROM authors WHERE name = 'Juan Perez')),

    ('Hot Accessories', 986, 105,
    (SELECT id FROM authors WHERE name = 'Maria Charlotte')),

    ('Refinishing Wood Floors', 1571, 7542,
    (SELECT id FROM authors WHERE name = 'Gemma Alcocer'));

SELECT a.name AS author,
       t.title,
       t.word_count,
       t.views
FROM authors a
    JOIN titles t ON a.id = t.author_id
ORDER BY t.views DESC;