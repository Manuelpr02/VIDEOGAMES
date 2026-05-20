using UnityEngine;
using UnityEngine.SceneManagement;

#if UNITY_EDITOR
using UnityEditor;
#endif

public class MenuInicial : MonoBehaviour
{
    [Header("Configuración")]
    public string nombreDelPrimerNivel = "Nivel1"; // Asegúrate de que coincida con tu escena

    void Start()
    {
        // Aseguramos que el cursor sea visible al entrar al menú
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
    }

    // FUNCIÓN PARA EMPEZAR A JUGAR
    public void Jugar()
    {
        // Opcional: Si quieres que cada vez que empiece desde el menú se borren los récords anteriores
        PlayerPrefs.DeleteAll();

        SceneManager.LoadScene(nombreDelPrimerNivel);
    }

    // FUNCIÓN PARA SALIR
    public void Salir()
    {
        Debug.Log("Saliendo del juego...");

        Application.Quit();

#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#endif
    }
}