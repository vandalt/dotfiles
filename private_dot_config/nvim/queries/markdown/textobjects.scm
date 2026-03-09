;; extends

; Not using @block so cell is captured even when inside code block which has its own blocks
(fenced_code_block
  (code_fence_content) @cell.inner) @cell.outer

(section) @section.outer

((section) @section.inner (#offset! @section.inner 1 0 0 0))
