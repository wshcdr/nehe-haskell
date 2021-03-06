module Main where

import Graphics.UI.GLUT
import Graphics.Rendering.OpenGL
import Control.Concurrent (threadDelay)
import Data.Maybe (fromJust)
import Data.IORef

main = do
    (progname, _) <- getArgsAndInitialize
    initialDisplayMode $= [ SingleBuffered, RGBMode
                          , WithAlphaComponent, WithDepthBuffer]
    initialWindowSize  $= Size 640 480
    initialWindowPosition $= Position 0 0
    createWindow "Nehe's GL Tutorial in Haskell"

    ioRtri <- newIORef 0.0
    ioRquad <- newIORef 0.0

    displayCallback $= drawGLScene ioRtri ioRquad
    fullScreen
    idleCallback $= Just (drawGLScene ioRtri ioRquad)
    reshapeCallback $= Just resizeGLScene
    keyboardMouseCallback $= Just keyPressed
    initGL $ Size 640 480
    mainLoop

initGL size@(Size w h) = do
    clearColor $= Color4 0 0 0 0
    clearDepth $= 1
    depthFunc  $= Just Less
    shadeModel $= Smooth
    matrixMode $= Projection
    loadIdentity
    let h' = if h == 0 then 1 else h
    perspective 45 (fromIntegral w / fromIntegral h') 0.1 100
    matrixMode $= Modelview 0

resizeGLScene size@(Size w h) = do
    viewport   $= (Position 0 0, size)
    matrixMode $= Projection
    loadIdentity
    let h' = if h == 0 then 1 else h
    perspective 45 (fromIntegral w / fromIntegral h') 0.1 100
    matrixMode $= Modelview 0

keyPressed key keyState modifiers position = do
    threadDelay 100
    case key of
        Char '\ESC' -> do
            window <- fmap fromJust $ get currentWindow
            destroyWindow window
        _ -> return ()

drawGLScene ioRtri ioRquad = do
    rtri <- readIORef ioRtri
    rquad <- readIORef ioRquad
    modifyIORef ioRtri (+15)
    modifyIORef ioRquad (+15)

    clear [ColorBuffer, DepthBuffer]

    loadIdentity
    translate $ Vector3 (-1.5) 0 ((-6)::GLfloat)
    rotate rtri $ Vector3 0 1 (0::GLfloat)
    renderPrimitive Triangles $ do
        color  $ color3f 1 0 0
        vertex $ Vertex3 0 1 (0::GLfloat)

        color  $ color3f 0 1 0
        vertex $ Vertex3 (-1) (-1) (0::GLfloat)

        color  $ color3f 0 0 1
        vertex $ Vertex3 1 (-1) (0::GLfloat)

    loadIdentity
    translate $ Vector3 1.5 0 ((-6)::GLfloat)
    rotate rquad $ Vector3 1 0 (0::GLfloat)
    color $ color3f 0.5 0.5 1
    renderPrimitive Quads $ do
        vertex $ Vertex3 (-1) 1 (0::GLfloat)
        vertex $ Vertex3 1 1 (0::GLfloat)
        vertex $ Vertex3 1 (-1) (0::GLfloat)
        vertex $ Vertex3 (-1) (-1) (0::GLfloat)

    swapBuffers
  where
    color3f :: GLfloat -> GLfloat -> GLfloat -> Color3 GLfloat
    color3f = Color3
