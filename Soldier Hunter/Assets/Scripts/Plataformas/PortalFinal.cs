using UnityEngine;
using TMPro;

public class PortalFinal : MonoBehaviour
{
    [Header("Requisitos")]
    public int heroesNecesarios = 5; // Cuántos soldados debe matar
    public string nombreEscenaFinal = "EscenaVictoria"; // Nombre de la pantalla de fin

    [Header("Interfaz Mensaje")]
    public TextMeshProUGUI textoAviso; // Texto que dirá "Te faltan X"
    public float tiempoVisible = 3f;

    private void Start()
    {
        if (textoAviso != null) textoAviso.gameObject.SetActive(false);
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            MovimientoEnemigo jugador = collision.GetComponent<MovimientoEnemigo>();

            if (jugador != null)
            {
                // Consultamos al jugador cuántos héroes ha matado
                int bajasActuales = jugador.GetBajasHeroes();

                if (bajasActuales >= heroesNecesarios)
                {
                    // --- CAMBIO IMPORTANTE AQUÍ ---
                    // No usamos LoadScene directamente. 
                    // Llamamos a la función del jugador que guarda las estadísticas.
                    jugador.GanarNivel();
                }
                else
                {
                    // No tiene suficientes, mostramos mensaje
                    int faltantes = heroesNecesarios - bajasActuales;
                    MostrarMensaje(faltantes);
                }
            }
        }
    }

    void MostrarMensaje(int cantidad)
    {
        if (textoAviso != null)
        {
            textoAviso.text = "¡Aún no! Te falta eliminar a " + cantidad + " héroes.";
            textoAviso.gameObject.SetActive(true);
            CancelInvoke("OcultarMensaje");
            Invoke("OcultarMensaje", tiempoVisible);
        }
    }

    void OcultarMensaje()
    {
        if (textoAviso != null) textoAviso.gameObject.SetActive(false);
    }
}