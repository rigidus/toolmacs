(require 'cl-lib)

(defun get-org-code-blocks ()
  "Retrieve all code blocks with their names from the current org-mode buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let (code-blocks)
      (while (re-search-forward "#\\+BEGIN_SRC[ \t]+\\([^ \f\t\n\r\v]+\\)[^\\S-]*" nil t)
        (let* ((pnt (org-element-at-point))
               (lang (match-string-no-properties 1))
               (name (org-element-property :name (org-element-at-point)))
               (value (org-element-property :value (org-element-at-point))))
          ;; (message "\n->[%s](%s){%s}\n%s" name lang pnt value)
          (if (and name
                   (not (equal lang "elisp"))
                   (not (equal lang "ditaa")))
              (push (list :name name :lang lang :value value) code-blocks))))
      (setq code-blocks (nreverse code-blocks))
      code-blocks)))

(defun find-ref (input-string)
  "Find all code-block refs in the given string."
  (let ((regex "<<\\([a-z0-9-_]*?\\)>>" )
        (matches '())
        (match-start))
    (while (string-match regex input-string match-start)
      (push (match-string 1 input-string) matches)
      (setq match-start (match-end 0)))
    (nreverse matches)))

(defvar org-code-graph '()
  "Variable to store the directed acyclic graph (DAG) representing code block dependencies.")

(defun add-vertex (vertex)
  "Add a vertex to the graph if it doesn't already exist."
  (unless (assoc vertex org-code-graph)
    (push `(,vertex . ()) org-code-graph)))

(defun add-edge (from to)
  "Add a directed edge from FROM to TO in the graph."
  (let ((vertex (assoc from org-code-graph)))
    (when vertex
      (setf (cdr vertex) (cons to (cdr vertex))))))

(defun build-org-code-graph ()
  "Build a directed acyclic graph (DAG) representing code block dependencies."
  (interactive)
  (let ((org-code-graph '())
        (code-blocks (get-org-code-blocks)))
    ;; Add vertices for each code block
    (dolist (block code-blocks)
      (add-vertex (getf block :name)))
    ;; Add edges for each reference within code blocks
    (dolist (block code-blocks)
      (let* ((block-name (getf block :name))
             (block-references (find-ref (getf block :value))))
        (dolist (ref block-references)
          (add-edge block-name ref))))
    org-code-graph))

(defun org-code-graph-to-dot (org-code-graph)
  "Convert org-code-graph to DOT format."
  (let ((org-code-dot ""))
    ;; Add the opening line for DOT graph
    (setf org-code-dot (concat org-code-dot "digraph G {\n"))
    ;; Add vertices to DOT
    (dolist (vertex-pair org-code-graph)
      (setf org-code-dot (concat org-code-dot (format "  \"%s\";\n" (car vertex-pair)))))
    ;; Add edges to DOT
    (dolist (vertex-pair org-code-graph)
      (let ((vertex (car vertex-pair))
            (dependencies (cdr vertex-pair)))
        (dolist (dependency dependencies)
          (setf org-code-dot
                (concat org-code-dot
                        (format "  \"%s\" -> \"%s\";\n" vertex dependency))))))
    ;; Add the closing line for DOT graph
    (setf org-code-dot (concat org-code-dot "}\n"))
    org-code-dot))

;; Example usage:
(message "%s"
         (org-code-graph-to-dot (build-org-code-graph)))
