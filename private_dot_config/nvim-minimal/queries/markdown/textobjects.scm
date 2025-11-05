;; extends

; NOTE: Not using @block so cell is captured even when inside code block which has its own blocks
(fenced_code_block
  (code_fence_content) @cell.inner) @cell.outer
