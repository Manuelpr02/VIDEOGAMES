using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement; // Necesario para cambiar de escenas

public class PantallaVictoria : MonoBehaviour
{
    [Header("Referencias de Texto")]
    public TextMeshProUGUI textoCiudadanos;
    public TextMeshProUGUI textoTiempo;
    public TextMeshProUGUI textoMuertes;

    void Start()
    {
        // Recuperamos los datos guardados de la sesión anterior
        int ciudadanos = PlayerPrefs.GetInt("FinalCiudadanos", 0);
        float tiempoTotal = PlayerPrefs.GetFloat("FinalTiempo", 0f);
        int muertes = PlayerPrefs.GetInt("FinalMuertes", 0);

        // Formateamos el tiempo
        int minutos = Mathf.FloorToInt(tiempoTotal / 60);
        int segundos = Mathf.FloorToInt(tiempoTotal % 60);

        // Mostramos los datos en la pantalla
        if (textoCiudadanos != null) textoCiudadanos.text = "Ciudadanos eliminados: " + ciudadanos;
        if (textoTiempo != null) textoTiempo.text = "Tiempo total: " + string.Format("{0:00}:{1:00}", minutos, segundos);
        if (textoMuertes != null) textoMuertes.text = "Veces muerto: " + muertes;

        // Hacemos que el cursor sea visible para poder clicar los botones
        Cursor.visible = true;
        Cursor.lockState = CursorLockMode.None;
    }

    // FUNCIÓN PARA EL BOTÓN REINICIAR
    public void ReiniciarJuego()
    {
        // Opcional: Limpiamos los PlayerPrefs si quieres que las estadísticas 
        // empiecen de cero en la nueva partida
        PlayerPrefs.DeleteAll();

        // Carga la escena del primer nivel. 
        // ASEGÚRATE de que el nombre entre comillas sea EXACTAMENTE el de tu escena.
        SceneManager.LoadScene("Nivel1");
    }

    // FUNCIÓN PARA VOLVER AL MENÚ (La que ya tenías)
    public void VolverAlMenu()
    {
        SceneManager.LoadScene("MenuPrincipal");
    }

    // FUNCIÓN PARA EL BOTÓN CERRAR JUEGO
    public void SalirDelJuego()
    {
        Debug.Log("Cerrando aplicación..."); // Solo se ve en la consola de Unity

        #if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
        #endif

        Application.Quit(); // Cierra el juego (solo funciona en el juego exportado .exe)
    }
}