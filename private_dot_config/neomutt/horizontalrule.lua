-- horizontalrule.lua

function HorizontalRule ()
  return {
    pandoc.RawBlock('html', '__________________________________'),
  }
end
