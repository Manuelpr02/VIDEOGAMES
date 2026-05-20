using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;
using System.Collections.Generic;
using System.Collections;

public class MovimientoEnemigo : MonoBehaviour
{
    [Header("Salud y Estadísticas")]
    public int vidas = 4;
    public int vidaMaxima = 5;
    private int bajasHeroes = 0;
    private int bajasCiudadanos = 0;
    private int contadorMuertesTotales = 0;

    [Header("Invencibilidad y Feedback")]
    public float tiempoInvencible = 2f;
    public Color colorInvencible = new Color(1f, 1f, 1f, 0.5f);
    private bool esInvencible = false;
    private Color colorOriginal;

    [Header("Sonidos")]
    public AudioClip sonidoMuerteCiudadano;
    public AudioClip sonidoMuerteHeroe;
    public AudioClip sonidoColeccionableVida;
    private AudioSource fuenteAudio;

    [Header("Interfaz (UI)")]
    public TextMeshProUGUI textoVida;
    public TextMeshProUGUI textoBajasHeroes;
    public TextMeshProUGUI textoBajasCiudadanos;
    public TextMeshProUGUI textoCronometro;

    [Header("Configuración Control")]
    public float velocidadJugador = 5f;
    public float fuerzaSalto = 6f;
    public int saltosMaximos = 2;

    private Rigidbody2D rb;
    private SpriteRenderer spriteRenderer;
    private Animator anim;
    private bool tocandoSuelo;
    private int saltosRestantes;

    private Vector2 puntoSpawnInicial;
    private Vector2 puntoRespawn;

    void Start()
    {
        rb = GetComponent<Rigidbody2D>();
        spriteRenderer = GetComponent<SpriteRenderer>();
        anim = GetComponent<Animator>();
        fuenteAudio = GetComponent<AudioSource>(); // Inicializamos el componente de audio

        // Guardamos posiciones iniciales
        puntoSpawnInicial = transform.position;
        puntoRespawn = transform.position;

        if (spriteRenderer != null) colorOriginal = spriteRenderer.color;

        saltosRestantes = saltosMaximos;
        gameObject.tag = "Player";

        ActualizarUI();
    }

    void Update()
    {
        ManejarControlJugador();
        ActualizarCronometro();
    }

    void ActualizarCronometro()
    {
        if (textoCronometro != null)
        {
            float tiempo = Time.timeSinceLevelLoad;
            int minutos = Mathf.FloorToInt(tiempo / 60);
            int segundos = Mathf.FloorToInt(tiempo % 60);
            textoCronometro.text = string.Format("{0:00}:{1:00}", minutos, segundos);
        }
    }

    void ManejarControlJugador()
    {
        float entradaX = Input.GetAxisRaw("Horizontal");
        if (rb != null) rb.linearVelocity = new Vector2(entradaX * velocidadJugador, rb.linearVelocity.y);

        if (Input.GetKeyDown(KeyCode.S) && anim != null) anim.SetTrigger("Atacar");

        if (anim != null)
        {
            anim.SetFloat("Velocidad", Mathf.Abs(entradaX));
            anim.SetBool("estaSaltando", !tocandoSuelo);
        }

        if (spriteRenderer != null)
        {
            if (entradaX > 0.1f) spriteRenderer.flipX = false;
            else if (entradaX < -0.1f) spriteRenderer.flipX = true;
        }

        if (Input.GetButtonDown("Jump") && saltosRestantes > 0)
        {
            if (rb != null)
            {
                rb.linearVelocity = new Vector2(rb.linearVelocity.x, 0);
                rb.AddForce(Vector2.up * fuerzaSalto, ForceMode2D.Impulse);
            }
            saltosRestantes--;
            tocandoSuelo = false;
        }
    }

    // --- SISTEMA DE DAÑO, MUERTE Y VACÍO ---

    public void TomarDanio(int cantidad)
    {
        if (esInvencible) return;

        vidas -= cantidad;
        ActualizarUI();

        if (vidas <= 0) RespawnDesdeCero();
        else StartCoroutine(PeriodoInvencibilidad());
    }

    public void CaidaAlVacio()
    {
        vidas--;
        ActualizarUI();

        if (vidas <= 0)
        {
            RespawnDesdeCero();
        }
        else
        {
            transform.position = puntoRespawn;
            if (rb != null) rb.linearVelocity = Vector2.zero;
            StartCoroutine(PeriodoInvencibilidad());
        }
    }

    IEnumerator PeriodoInvencibilidad()
    {
        esInvencible = true;
        if (spriteRenderer != null) spriteRenderer.color = colorInvencible;

        yield return new WaitForSeconds(tiempoInvencible);

        if (spriteRenderer != null) spriteRenderer.color = colorOriginal;
        esInvencible = false;
    }

    void RespawnDesdeCero()
    {
        contadorMuertesTotales++;
        transform.position = puntoSpawnInicial;
        puntoRespawn = puntoSpawnInicial;
        vidas = vidaMaxima;
        if (rb != null) rb.linearVelocity = Vector2.zero;
        StartCoroutine(PeriodoInvencibilidad());
        ActualizarUI();
    }

    // --- SISTEMA DE COMBATE ---

    public void GolpeDeAtaque()
    {
        float radioAtaque = 0.5f;
        bool mirandoIzquierda = (spriteRenderer != null) ? spriteRenderer.flipX : false;
        Vector2 puntoAtaque = (Vector2)transform.position + (mirandoIzquierda ? Vector2.left : Vector2.right) * 0.8f;

        Collider2D[] detectados = Physics2D.OverlapCircleAll(puntoAtaque, radioAtaque);
        List<GameObject> yaMuertos = new List<GameObject>();

        foreach (Collider2D col in detectados)
        {
            GameObject obj = col.gameObject;
            if (obj.CompareTag("Heroe") && !yaMuertos.Contains(obj))
            {
                yaMuertos.Add(obj);

                // Lógica de sonidos según el tipo de enemigo
                if (obj.GetComponent<CiudadanoIA>() != null)
                {
                    bajasCiudadanos++;
                    if (fuenteAudio != null && sonidoMuerteCiudadano != null)
                        fuenteAudio.PlayOneShot(sonidoMuerteCiudadano);
                }
                else
                {
                    bajasHeroes++;
                    if (fuenteAudio != null && sonidoMuerteHeroe != null)
                        fuenteAudio.PlayOneShot(sonidoMuerteHeroe);
                }

                Destroy(obj);
            }
        }
        ActualizarUI();
    }

    // --- UTILIDADES ---

    void ActualizarUI()
    {
        if (textoVida != null) textoVida.text = "Vidas: " + vidas;
        if (textoBajasHeroes != null) textoBajasHeroes.text = "Soldados: " + bajasHeroes;
        if (textoBajasCiudadanos != null) textoBajasCiudadanos.text = "Ciudadanos: " + bajasCiudadanos;
    }

    public void Curar(int cantidad)
    {
        // Sonido de curación
        if (fuenteAudio != null && sonidoColeccionableVida != null)
            fuenteAudio.PlayOneShot(sonidoColeccionableVida);

        vidas += cantidad;
        if (vidas > vidaMaxima) vidas = vidaMaxima;
        ActualizarUI();
    }

    public int GetBajasHeroes() => bajasHeroes;

    public void ActualizarCheckpoint(Vector2 nuevaPosicion)
    {
        puntoRespawn = nuevaPosicion;
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Suelo"))
        {
            tocandoSuelo = true;
            saltosRestantes = saltosMaximos;
        }
    }

    private void OnCollisionExit2D(Collision2D collision)
    {
        if (collision.gameObject.CompareTag("Suelo")) tocandoSuelo = false;
    }

    private void OnDrawGizmosSelected()
    {
        SpriteRenderer sr = GetComponent<SpriteRenderer>();
        if (sr == null) return;

        Gizmos.color = Color.yellow;
        Vector2 puntoAtaque = (Vector2)transform.position + (sr.flipX ? Vector2.left : Vector2.right) * 0.8f;
        Gizmos.DrawWireSphere(puntoAtaque, 0.5f);
    }

    public void GanarNivel()
    {
        PlayerPrefs.SetInt("FinalCiudadanos", bajasCiudadanos);
        PlayerPrefs.SetFloat("FinalTiempo", Time.timeSinceLevelLoad);
        PlayerPrefs.SetInt("FinalMuertes", contadorMuertesTotales);

        SceneManager.LoadScene("EscenaVictoria");
    }
}