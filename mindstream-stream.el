;;; mindstream-stream.el --- Start writing, stay focused, don't worry -*- lexical-binding: t -*-

;; URL: https://github.com/countvajhula/mindstream

;; This work is "part of the world." You are free to do whatever you
;; like with it and it isn't owned by anybody, not even the creators.
;; Attribution would be appreciated and would help, but it is not
;; strictly necessary nor required.

;; The freely released, copyright-free work in this repository
;; represents an investment in a better way of doing things called
;; attribution-based economics (ABE). Attribution-based economics is
;; based on the simple idea that we gain more by giving more, not by
;; holding on to things that, truly, we could only create because we,
;; in our turn, received from others. As it turns out, an economic
;; system based on attribution -- where those who give more are more
;; empowered -- is significantly more efficient than capitalism while
;; also being stable and fair (unlike capitalism, on both counts),
;; giving it transformative power to elevate the human condition and
;; address the problems that face us today along with a host of others
;; that have been intractable since the beginning. You can help make
;; this a reality by releasing your work in the same way -- freely
;; into the public domain in the simple hope of providing value. Learn
;; more about attribution-based economics at drym.org, tell your
;; friends, do your part.

;; This is free and unencumbered software released into the public domain.
;; The authors relinquish any copyright claims on this work.
;;

;;; Commentary:

;; Mindstream "stream" abstraction (Git branches with moment-to-moment semantics)

;;; Code:

(require 'mindstream-backend)

(defun mindstream-stream-p (&optional buffer)
  "Predicate to check whether BUFFER is in an active stream."
  (string-prefix-p mindstream-branch-prefix
                   (mindstream-git-branch-name buffer)))

(defun mindstream--start-stream-helper ()
  "Do any necessary bookkeeping after starting a stream.

For instance, add the session to completion history."
  (add-to-list 'mindstream-session-history
               (mindstream--session-file-name-relative default-directory
                                                       mindstream-save-session-path))
  (message "Session started at %s." default-directory))

(defun mindstream--start-stream ()
  "Start stream."
  (mindstream-create-git-branch)
  ;; this may be OK as is, for now.
  ;; used in archive and load
  (mindstream--start-stream-helper))

(defun mindstream-start-stream ()
  "Start a new stream in the current repo.

A stream is an ordinary git branch with moment-to-moment commit
semantics. Any branch whose name starts with
`mindstream-branch-prefix' will be versioned this way."
  (interactive)
  (if (mindstream-stream-p)
      (when (y-or-n-p "Already in a mindstream session. Want to start a new one here?")
        (mindstream--start-stream))
    (mindstream--start-stream)))

(provide 'mindstream-stream)
;;; mindstream-stream.el ends here
