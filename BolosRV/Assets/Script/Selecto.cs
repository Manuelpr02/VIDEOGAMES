using UnityEngine;

public class Selecto : MonoBehaviour
{
    public Transform manoDerecha;

    public void Agarrar()
    {
        if (manoDerecha == null) return;

        // Quitamos la física para que no salga volando
        if (TryGetComponent<Rigidbody>(out Rigidbody rb))
        {
            rb.isKinematic = true;
            rb.linearVelocity = Vector3.zero; // Versión para Unity 6
        }

        // Lo pegamos a la mano
        transform.SetParent(manoDerecha);

        // RESET TOTAL: Lo ponemos en el centro de la mano y con tamaño normal
        transform.localPosition = Vector3.zero;
        transform.localRotation = Quaternion.identity;
        transform.localScale = Vector3.one; // Esto evita que desaparezca por escala
    }

    public void Soltar()
    {
        transform.SetParent(null);
        if (TryGetComponent<Rigidbody>(out Rigidbody rb))
        {
            rb.isKinematic = false;
        }
    }
}